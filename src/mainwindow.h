#ifndef CLUE_MAINWINDOW_H
#define CLUE_MAINWINDOW_H

#include <QMainWindow>

#include "clue/game.h"

namespace Clue {

namespace Ui { class MainWindow; }

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr, std::shared_ptr<Clue::Game> gamePtr_in = nullptr);
    ~MainWindow();

private slots:
    void on_actionHistory_triggered();

    void on_submitTurn_accepted();

    void on_submitTurn_rejected();

private:
    Ui::MainWindow *ui;
    std::shared_ptr<Clue::Game> gamePtr;
};

} // namespace Clue
#endif // CLUE_MAINWINDOW_H
