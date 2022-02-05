#include "configuregame.h"
#include "ui_configuregame.h"
#include "mainwindow.h"
#include "clue/game.h"

#include <QStringListModel>

namespace Clue
{

    ConfigureGame::ConfigureGame(QWidget *parent) : QDialog(parent),
                                                    ui(new Ui::ConfigureGame)
    {
        this->setModal(true);
        ui->setupUi(this);
        on_numPlayers_valueChanged(3);
    }

    ConfigureGame::~ConfigureGame()
    {
        delete ui;
    }

    void ConfigureGame::updateWhosFirstList()
    {
        QStringList list;
        list.append(ui->p0Name->displayText());
        list.append(ui->p1Name->displayText());
        list.append(ui->p2Name->displayText());

        if (ui->p3Name->isEnabled())
        {
            list.append(ui->p3Name->displayText());
        }
        if (ui->p4Name->isEnabled())
        {
            list.append(ui->p4Name->displayText());
        }
        if (ui->p5Name->isEnabled())
        {
            list.append(ui->p5Name->displayText()); // 6 players
        }
        list.removeDuplicates();
        whosFirstListModel.setStringList(list);
        ui->whosFirst->setModel(&whosFirstListModel);
    }

    void ConfigureGame::on_numPlayers_valueChanged(int arg1)
    {
        ui->p0Name->setEnabled(true);
        ui->p1Name->setEnabled(true);
        ui->p2Name->setEnabled(true);

        ui->p3Name->setEnabled(3 < arg1); // at least 4 players
        ui->p4Name->setEnabled(4 < arg1); // at least 5 players
        ui->p5Name->setEnabled(5 < arg1); // 6 players
        updateWhosFirstList();
    }

    void ConfigureGame::on_p0Name_textChanged(const QString &arg1)
    {
        updateWhosFirstList();
    }

    void ConfigureGame::on_p1Name_textChanged(const QString &arg1)
    {
        updateWhosFirstList();
    }

    void ConfigureGame::on_p2Name_textChanged(const QString &arg1)
    {
        updateWhosFirstList();
    }

    void ConfigureGame::on_p3Name_textChanged(const QString &arg1)
    {
        updateWhosFirstList();
    }

    void ConfigureGame::on_p4Name_textChanged(const QString &arg1)
    {
        updateWhosFirstList();
    }

    void ConfigureGame::on_p5Name_textChanged(const QString &arg1)
    {
        updateWhosFirstList();
    }

    void ConfigureGame::on_buttonBox_accepted()
    {
        clueGame->setWhoGoesFirst(ui->whosFirst->currentText().toStdString());
        std::vector<std::string> players;
        players.push_back(ui->p0Name->displayText().toStdString());
        players.push_back(ui->p1Name->displayText().toStdString());
        players.push_back(ui->p2Name->displayText().toStdString());

        if (ui->p3Name->isEnabled())
        {
            players.push_back(ui->p3Name->displayText().toStdString());
        }
        if (ui->p4Name->isEnabled())
        {
            players.push_back(ui->p4Name->displayText().toStdString());
        }
        if (ui->p5Name->isEnabled())
        {
            players.push_back(ui->p5Name->displayText().toStdString()); // 6 players
        }
        clueGame->createGame(players);
        this->hide();
        // this->accept();
    }

    std::shared_ptr<Clue::Game> ConfigureGame::getGame() {
        return clueGame;
    }

} // namespace Clue
