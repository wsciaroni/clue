#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include "clue/constants.h"
#include <glog/logging.h>

namespace Clue {

MainWindow::MainWindow(QWidget *parent, std::shared_ptr<Clue::Game> gamePtr_in)
    : QMainWindow(parent)
    , gamePtr(gamePtr_in)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->playersTurnComboBox->setModel(gamePtr->getPlayersQStringListModel().get());
    ui->whoAnsweredComboBox->setModel(gamePtr->getPlayersQStringListModel().get());
    ui->weaponGuessedComboBox->setModel(gamePtr->getWeaponsQStringListModel().get());
    ui->suspectGuessedComboBox->setModel(gamePtr->getSuspectsQStringListModel().get());
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
    try
    {
        if (gamePtr != nullptr)
        {
            if (iSawOrShowedACard())
            {
                // I showed the card or I was showed the card
                list.append(ui->suspectGuessedComboBox->currentText());
                list.append(ui->weaponGuessedComboBox->currentText());
                list.append(ui->roomGuessedComboBox->currentText());
                ui->cardShownComboBox->setEnabled(true);
            }
            else
            {
                // I don't know what card it was
                list.append(Clue::Card::ToString(Clue::Card::NONE));
                ui->cardShownComboBox->setEnabled(false);
            }
        }
    }
    catch (const std::exception &e)
    {
        LOG(WARNING) << e.what();
    }
    listModel.setStringList(list);
    ui->cardShownComboBox->setModel(&listModel);
}

void MainWindow::setWhoAnswered() {
    try {
        static QStringListModel whoAnsweredModel;
        QStringList list;
        list.clear();
        for(const auto& a : gamePtr->getWholePlayerListStrings()) {
            if(a == ui->playersTurnComboBox->currentText()) {
                list.append(QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)));
            } else {
                list.append(a);
            }
        }
        whoAnsweredModel.setStringList(list);
        ui->whoAnsweredComboBox->setModel(&whoAnsweredModel);
    }
    catch (const std::exception &e)
    {
        LOG(WARNING) << e.what();
    }
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

bool MainWindow::iSawOrShowedACard() {
    try
    {
        // True if (it's my turn and someone answered), or I showed a card
        return (((QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)) != ui->whoAnsweredComboBox->currentText())
                && (gamePtr->getPlayerByName(ui->playersTurnComboBox->currentText().toStdString())->isMaster()))
                || (gamePtr->getPlayerByName(ui->whoAnsweredComboBox->currentText().toStdString())->isMaster()));
    }
    catch(Game::PlayerNotFoundByName e)
    {
        LOG(WARNING) << e.what();
        return false;
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
        std::shared_ptr<Player> playerWhoAnswered = nullptr;
        try
        {
            playerWhoAnswered = gamePtr->getPlayerByName(ui->whoAnsweredComboBox->currentText().toStdString());
        }
        catch(Game::PlayerNotFoundByName e)
        {
            LOG(WARNING) << e.what();
            playerWhoAnswered = playersTurn;
        }

        auto turn = std::make_shared<Turn>(
        playersTurn,
        ui->accusationMade->isChecked()||!ui->accusationNotMade->isChecked(),
        Suspect::FromString(ui->suspectGuessedComboBox->currentText().toStdString().c_str()),
        Weapon::FromString(ui->weaponGuessedComboBox->currentText().toStdString().c_str()),
        Room::FromString(ui->roomGuessedComboBox->currentText().toStdString().c_str()),
        playerWhoAnswered,
        Card::FromString(ui->cardShownComboBox->currentText().toStdString().c_str()),
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


void MainWindow::on_suspectGuessedComboBox_currentTextChanged(const QString &arg1)
{
    LOG(INFO) << "on_suspectGuessedComboBox_currentTextChanged" << std::endl;
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
    setPossibleCards();
}


void MainWindow::on_playersTurnComboBox_currentTextChanged(const QString &arg1)
{
    LOG(INFO) << "on_playersTurnComboBox_currentTextChanged" << std::endl;
    setWhoAnswered();
}


void MainWindow::on_accusationMade_clicked()
{
    LOG(INFO) << "on_accusationMade_clicked" << std::endl;

    ui->suspectGuessedComboBox->setEnabled(true);
    ui->weaponGuessedComboBox->setEnabled(true);
    ui->roomGuessedComboBox->setEnabled(true);
    ui->whoAnsweredComboBox->setEnabled(true);
    ui->cardShownComboBox->setEnabled(true);
    setWhoAnswered();
    setPossibleCards();
}


void MainWindow::on_accusationNotMade_clicked()
{
    LOG(INFO) << "on_accusationNotMade_clicked" << std::endl;

    ui->suspectGuessedComboBox->setCurrentText(QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)));
    ui->suspectGuessedComboBox->setEnabled(false);

    ui->weaponGuessedComboBox->setCurrentText(QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)));
    ui->weaponGuessedComboBox->setEnabled(false);

    ui->roomGuessedComboBox->setCurrentText(QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)));
    ui->roomGuessedComboBox->setEnabled(false);

    ui->whoAnsweredComboBox->setCurrentText(QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)));
    ui->whoAnsweredComboBox->setEnabled(false);

    ui->cardShownComboBox->setEnabled(false);

    setPossibleCards();
}


} // namespace Clue
