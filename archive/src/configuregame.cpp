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

        ui->card0->setModel(clueGame->getCardQStringListModel().get());
        ui->card1->setModel(clueGame->getCardQStringListModel().get());
        ui->card2->setModel(clueGame->getCardQStringListModel().get());
        ui->card3->setModel(clueGame->getCardQStringListModel().get());
        ui->card4->setModel(clueGame->getCardQStringListModel().get());
        ui->card5->setModel(clueGame->getCardQStringListModel().get());
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

        // Players
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

        // Hand
        std::set<Card> myHand;
        myHand.insert(Card::FromString(ui->card0->currentText().toStdString().c_str()));
        myHand.insert(Card::FromString(ui->card1->currentText().toStdString().c_str()));
        myHand.insert(Card::FromString(ui->card2->currentText().toStdString().c_str()));
        if(ui->card3->isEnabled()) {
            myHand.insert(Card::FromString(ui->card3->currentText().toStdString().c_str()));
        }
        if(ui->card4->isEnabled()) {
            myHand.insert(Card::FromString(ui->card4->currentText().toStdString().c_str()));
        }
        if(ui->card5->isEnabled()) {
            myHand.insert(Card::FromString(ui->card5->currentText().toStdString().c_str()));
        }

        clueGame->createGame(players, myHand);
        this->hide();
        // this->accept();
    }

    std::shared_ptr<Clue::Game> ConfigureGame::getGame() {
        return clueGame;
    }


void ConfigureGame::on_numCardsInHand_valueChanged(int arg1)
{
    ui->card0->setEnabled(true);
    ui->card1->setEnabled(true);
    ui->card2->setEnabled(true);

    ui->card3->setEnabled(3 < arg1); // at least 4 players
    ui->card4->setEnabled(4 < arg1); // at least 5 players
    ui->card5->setEnabled(5 < arg1); // 6 players
}

} // namespace Clue
