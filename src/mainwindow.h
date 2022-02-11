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

private:
    void setPossibleCards();
    void setPossiblePlayers();
    void setWhoAnswered();
    void updateTableInfo();

private slots:
    void on_actionHistory_triggered();

    void on_submitTurn_accepted();

    void on_submitTurn_rejected();

    void on_personGuessedComboBox_currentTextChanged(const QString &arg1);

    void on_weaponGuessedComboBox_currentTextChanged(const QString &arg1);

    void on_roomGuessedComboBox_currentTextChanged(const QString &arg1);

    void on_whoAnsweredComboBox_currentTextChanged(const QString &arg1);

    void on_playersTurnComboBox_currentTextChanged(const QString &arg1);

    void on_accusationMade_clicked();

    void on_accusationNotMade_clicked();

private:
    Ui::MainWindow *ui;
    std::shared_ptr<Clue::Game> gamePtr;
};

} // namespace Clue
#endif // CLUE_MAINWINDOW_H
