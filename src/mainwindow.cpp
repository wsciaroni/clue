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
    ui->weaponSuggestedComboBox->setModel(gamePtr->getWeaponsQStringListModel().get());
    ui->suspectSuggestedComboBox->setModel(gamePtr->getSuspectsQStringListModel().get());
    ui->roomSuggestedComboBox->setModel(gamePtr->getRoomsQStringListModel().get());
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
                list.append(ui->suspectSuggestedComboBox->currentText());
                list.append(ui->weaponSuggestedComboBox->currentText());
                list.append(ui->roomSuggestedComboBox->currentText());
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
        LOG(WARNING) << e.what() << " " << ui->playersTurnComboBox->currentText().toStdString() << " or " << ui->whoAnsweredComboBox->currentText().toStdString();
        return false;
    }
}

void MainWindow::on_actionHistory_triggered()
{
    DLOG(INFO) << "on_actionHistory_triggered" << std::endl;
}


void MainWindow::on_submitTurn_accepted()
{
    DLOG(INFO) << "on_submitTurn_accepted" << std::endl;
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
            LOG(WARNING) << e.what() << " " << ui->whoAnsweredComboBox->currentText().toStdString();
            playerWhoAnswered = playersTurn;
        }

        auto turn = std::make_shared<Turn>(
        playersTurn,
        ui->suggestionMade->isChecked()||!ui->suggestionNotMade->isChecked(),
        Suspect::FromString(ui->suspectSuggestedComboBox->currentText().toStdString().c_str()),
        Weapon::FromString(ui->weaponSuggestedComboBox->currentText().toStdString().c_str()),
        Room::FromString(ui->roomSuggestedComboBox->currentText().toStdString().c_str()),
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
    DLOG(INFO) << "on_submitTurn_rejected" << std::endl;
}


void MainWindow::on_suspectSuggestedComboBox_currentTextChanged(const QString &arg1)
{
    DLOG(INFO) << "on_suspectSuggestedComboBox_currentTextChanged" << std::endl;
    setPossibleCards();
}


void MainWindow::on_weaponSuggestedComboBox_currentTextChanged(const QString &arg1)
{
    DLOG(INFO) << "on_weaponSuggestedComboBox_currentTextChanged" << std::endl;
    setPossibleCards();
}


void MainWindow::on_roomSuggestedComboBox_currentTextChanged(const QString &arg1)
{
    DLOG(INFO) << "on_roomSuggestedComboBox_currentTextChanged" << std::endl;
    setPossibleCards();
}


void MainWindow::on_whoAnsweredComboBox_currentTextChanged(const QString &arg1)
{
    DLOG(INFO) << "on_whoAnsweredComboBox_currentTextChanged" << std::endl;
    setPossibleCards();
}


void MainWindow::on_playersTurnComboBox_currentTextChanged(const QString &arg1)
{
    DLOG(INFO) << "on_playersTurnComboBox_currentTextChanged" << std::endl;
    setWhoAnswered();
}


void MainWindow::on_suggestionMade_clicked()
{
    DLOG(INFO) << "on_suggestionMade_clicked" << std::endl;

    ui->suspectSuggestedComboBox->setEnabled(true);
    ui->weaponSuggestedComboBox->setEnabled(true);
    ui->roomSuggestedComboBox->setEnabled(true);
    ui->whoAnsweredComboBox->setEnabled(true);
    ui->cardShownComboBox->setEnabled(true);
    setWhoAnswered();
    setPossibleCards();
}


void MainWindow::on_suggestionNotMade_clicked()
{
    DLOG(INFO) << "on_suggestionNotMade_clicked" << std::endl;

    ui->suspectSuggestedComboBox->setCurrentText(QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)));
    ui->suspectSuggestedComboBox->setEnabled(false);

    ui->weaponSuggestedComboBox->setCurrentText(QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)));
    ui->weaponSuggestedComboBox->setEnabled(false);

    ui->roomSuggestedComboBox->setCurrentText(QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)));
    ui->roomSuggestedComboBox->setEnabled(false);

    ui->whoAnsweredComboBox->setCurrentText(QString::fromStdString(Clue::Card::ToString(Clue::Card::NONE)));
    ui->whoAnsweredComboBox->setEnabled(false);

    ui->cardShownComboBox->setEnabled(false);

    setPossibleCards();
}


} // namespace Clue
