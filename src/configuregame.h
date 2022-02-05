#ifndef CLUE_CONFIGUREGAME_H
#define CLUE_CONFIGUREGAME_H

#include <QDialog>
#include <QStringListModel>
#include "clue/game.h"

namespace Clue {

namespace Ui {
class ConfigureGame;
}

class ConfigureGame : public QDialog
{
    Q_OBJECT

public:
    explicit ConfigureGame(QWidget *parent = nullptr);
    ~ConfigureGame();
    std::shared_ptr<Clue::Game> getGame();

private slots:
    void on_numPlayers_valueChanged(int arg1);

    void on_p0Name_textChanged(const QString &arg1);

    void on_p1Name_textChanged(const QString &arg1);

    void on_p2Name_textChanged(const QString &arg1);

    void on_p3Name_textChanged(const QString &arg1);

    void on_p4Name_textChanged(const QString &arg1);

    void on_p5Name_textChanged(const QString &arg1);

    void on_buttonBox_accepted();

private:
    Ui::ConfigureGame *ui;

    void updateWhosFirstList();
    QStringListModel whosFirstListModel;
    std::shared_ptr<Clue::Game> clueGame = std::make_shared<Clue::Game>();

};


} // namespace Clue
#endif // CLUE_CONFIGUREGAME_H
