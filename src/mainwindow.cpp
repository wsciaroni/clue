#include "mainwindow.h"
#include "./ui_mainwindow.h"

namespace Clue {

MainWindow::MainWindow(QWidget *parent, std::shared_ptr<Clue::Game> gamePtr_in)
    : QMainWindow(parent)
    , gamePtr(gamePtr_in)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    // Ui::playersTurnComboBox->setModel(gamePtr->getPlayersQStringListModel);
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
}


void MainWindow::on_submitTurn_rejected()
{
  // Reset all the input boxes
  // @TODO
}


} // namespace Clue
