#include "mainwindow.h"
#include "clue/game.h"
#include <QApplication>
#include <QLocale>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    std::vector<std::string> players {
        "Will",
        "Abby",
        "Buddy The Elf"
    };
    auto clueGame = std::make_shared<Clue::Game>();
    clueGame->createGame(players);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "clue_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            a.installTranslator(&translator);
            break;
        }
    }
    Clue::MainWindow w(nullptr, clueGame);
    w.show();
    return a.exec();
}
