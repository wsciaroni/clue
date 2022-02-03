#ifndef CLUE_MAINWINDOW_H
#define CLUE_MAINWINDOW_H

#include <QMainWindow>

namespace Clue {

namespace Ui { class MainWindow; }

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_actionHistory_triggered();

    void on_submitTurn_accepted();

    void on_submitTurn_rejected();

private:
    Ui::MainWindow *ui;
};

} // namespace Clue
#endif // CLUE_MAINWINDOW_H
