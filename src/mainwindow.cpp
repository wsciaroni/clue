#include "mainwindow.h"
#include "./ui_mainwindow.h"

namespace Clue {

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
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


} // namespace Clue
