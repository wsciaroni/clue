#include "mainwindow.h"
#include "./ui_mainwindow.h"

#include <glog/logging.h>

namespace Clue {

MainWindow::MainWindow(QWidget *parent, std::shared_ptr<Clue::Game> gamePtr_in)
    : QMainWindow(parent)
    , gamePtr(gamePtr_in)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->playersTurnComboBox->setModel(gamePtr->getPlayersQStringListModel().get());
    ui->playerShownComboBox->setModel(gamePtr->getPlayersQStringListModel().get());
    ui->whoAnsweredComboBox->setModel(gamePtr->getPlayersQStringListModel().get());
    ui->weaponGuessedComboBox->setModel(gamePtr->getWeaponsQStringListModel().get());
    ui->personGuessedComboBox->setModel(gamePtr->getCharactersQStringListModel().get());
    ui->roomGuessedComboBox->setModel(gamePtr->getRoomsQStringListModel().get());
    ui->cardShownComboBox->setModel(gamePtr->getCardQStringListModel().get());
    ui->turnListView->setModel(gamePtr->getTurnsStringListModel().get());
    updateTableInfo();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::setPossibleCards() {
    static QStringListModel listModel;
    QStringList list;
    list.append(ui->personGuessedComboBox->currentText());
    list.append(ui->weaponGuessedComboBox->currentText());
    list.append(ui->roomGuessedComboBox->currentText());
    listModel.setStringList(list);
    ui->cardShownComboBox->setModel(&listModel);
}

void MainWindow::setPossiblePlayers() {
    static QStringListModel listModel;
    QStringList list;
    list.append(ui->whoAnsweredComboBox->currentText());
    list.append(ui->playersTurnComboBox->currentText());
    list.append("NONE");
    listModel.setStringList(list);
    ui->playerShownComboBox->setModel(&listModel);
}

void MainWindow::setWhoAnswered() {
    if (gamePtr != nullptr)
    {
        static QStringListModel whoAnsweredModel;
        whoAnsweredModel.setStringList(gamePtr->getWholePlayerListStrings());
        ui->whoAnsweredComboBox->setModel(&whoAnsweredModel);
    }
    LOG(WARNING) << "gamePtr == nullptr";
}

void MainWindow::updateTableInfo() {
//    ui->knownInfoTableWidget->clearContents();
    gamePtr->runAnalysis();
    ui->knownInfoTableWidget->setColumnCount(gamePtr->getNumberOfPlayers()+1);
    ui->knownInfoTableWidget->setRowCount(NUMBER_OF_CARDS+1);

    auto tableInfo = gamePtr->getTableInfo();
    int i = 0;
    for(auto row : (*tableInfo)) {
        int j = 0;
        for( auto column : row) {
            LOG(INFO) << i << "," << j << (*tableInfo)[i][j] << std::endl;
            ui->knownInfoTableWidget->setItem(i,j,new QTableWidgetItem(QString::fromStdString((*tableInfo)[i][j])));
            j++;
        }
        i++;
    }
}

void MainWindow::on_actionHistory_triggered()
{
    LOG(INFO) << "on_actionHistory_triggered" << std::endl;
}


void MainWindow::on_submitTurn_accepted()
{
    LOG(INFO) << "on_submitTurn_accepted" << std::endl;
    // Attempt to create a Turn
    try
    {
        auto playersTurn = gamePtr->getPlayerByName(ui->playersTurnComboBox->currentText().toStdString());
        auto playerWhoAnswered = gamePtr->getPlayerByName(ui->whoAnsweredComboBox->currentText().toStdString());
        auto playerShown = gamePtr->getPlayerByName(ui->playerShownComboBox->currentText().toStdString());

        auto turn = std::make_shared<Turn>(
        playersTurn,
        ui->accusationMade->isChecked()||!ui->accusationNotMade->isChecked(),
        Suspect::FromString(ui->personGuessedComboBox->currentText().toStdString().c_str()),
        Weapon::FromString(ui->weaponGuessedComboBox->currentText().toStdString().c_str()),
        Room::FromString(ui->roomGuessedComboBox->currentText().toStdString().c_str()),
        playerWhoAnswered,
        Card::FromString(ui->cardShownComboBox->currentText().toStdString().c_str()),
        playerShown,
        gamePtr->getPlayersBetween(playersTurn,playerWhoAnswered)
    );
    gamePtr->submitTurn(turn);
    updateTableInfo();
    }
    catch(const std::exception& e)
    {
        LOG(WARNING) << e.what();
    }
}


void MainWindow::on_submitTurn_rejected()
{
  // Reset all the input boxes
  // @TODO
    LOG(INFO) << "on_submitTurn_rejected" << std::endl;
}


void MainWindow::on_personGuessedComboBox_currentTextChanged(const QString &arg1)
{
    LOG(INFO) << "on_personGuessedComboBox_currentTextChanged" << std::endl;
    setPossibleCards();
}


void MainWindow::on_weaponGuessedComboBox_currentTextChanged(const QString &arg1)
{
    LOG(INFO) << "on_weaponGuessedComboBox_currentTextChanged" << std::endl;
    setPossibleCards();
}


void MainWindow::on_roomGuessedComboBox_currentTextChanged(const QString &arg1)
{
    LOG(INFO) << "on_roomGuessedComboBox_currentTextChanged" << std::endl;
    setPossibleCards();
}


void MainWindow::on_whoAnsweredComboBox_currentTextChanged(const QString &arg1)
{
    LOG(INFO) << "on_whoAnsweredComboBox_currentTextChanged" << std::endl;
    setPossiblePlayers();
}


void MainWindow::on_playersTurnComboBox_currentTextChanged(const QString &arg1)
{
    LOG(INFO) << "on_playersTurnComboBox_currentTextChanged" << std::endl;
    setPossiblePlayers();
    setWhoAnswered();
}


void MainWindow::on_accusationMade_clicked()
{
    LOG(INFO) << "on_accusationMade_clicked" << std::endl;

    ui->personGuessedComboBox->setEnabled(true);
    ui->weaponGuessedComboBox->setEnabled(true);
    ui->roomGuessedComboBox->setEnabled(true);
    ui->whoAnsweredComboBox->setEnabled(true);
    ui->cardShownComboBox->setEnabled(true);
    ui->playerShownComboBox->setEnabled(true);
    setPossiblePlayers();
    setWhoAnswered();
}


void MainWindow::on_accusationNotMade_clicked()
{
    LOG(INFO) << "on_accusationNotMade_clicked" << std::endl;

    ui->personGuessedComboBox->setCurrentText("NONE");
    ui->personGuessedComboBox->setEnabled(false);

    ui->weaponGuessedComboBox->setCurrentText("NONE");
    ui->weaponGuessedComboBox->setEnabled(false);

    ui->roomGuessedComboBox->setCurrentText("NONE");
    ui->roomGuessedComboBox->setEnabled(false);

    ui->whoAnsweredComboBox->setCurrentText("NONE");
    ui->whoAnsweredComboBox->setEnabled(false);

    ui->cardShownComboBox->setEnabled(false);

    ui->playerShownComboBox->setEnabled(false);
}


} // namespace Clue
