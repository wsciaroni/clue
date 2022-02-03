#include "mainwindow.h"
#include "./ui_mainwindow.h"

#include <iostream>

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
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_actionHistory_triggered()
{

}


void MainWindow::on_submitTurn_accepted()
{
    // Attempt to create a Turn
    // @TODO
    try
    {
        auto turn = std::make_shared<Turn>(
        gamePtr->getPlayerByName(ui->playersTurnComboBox->currentText().toStdString()),
        ui->accusationMade->isChecked()||!ui->accusationNotMade->isChecked(),
        Suspect::FromString(ui->personGuessedComboBox->currentText().toStdString().c_str()),
        Weapon::FromString(ui->weaponGuessedComboBox->currentText().toStdString().c_str()),
        Room::FromString(ui->roomGuessedComboBox->currentText().toStdString().c_str()),
        gamePtr->getPlayerByName(ui->whoAnsweredComboBox->currentText().toStdString()),
        Card::FromString(ui->cardShownComboBox->currentText().toStdString().c_str()),
        gamePtr->getPlayerByName(ui->playerShownComboBox->currentText().toStdString())
    );
    gamePtr->submitTurn(turn);
    }
    catch(const std::exception& e)
    {
        std::cerr << e.what() << '\n';
    }
}


void MainWindow::on_submitTurn_rejected()
{
  // Reset all the input boxes
  // @TODO
}


} // namespace Clue
