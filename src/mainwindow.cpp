#include "mainwindow.h"
#include "./ui_mainwindow.h"

namespace Clue {

MainWindow::MainWindow(QWidget *parent, std::shared_ptr<Clue::Game> gamePtr_in)
    : QMainWindow(parent)
    , gamePtr(gamePtr_in)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
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
