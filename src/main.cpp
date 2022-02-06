#include "mainwindow.h"
#include "clue/game.h"
#include "configuregame.h"

#include <QApplication>
#include <QLocale>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
     QTranslator translator;
     const QStringList uiLanguages = QLocale::system().uiLanguages();
     for (const QString &locale : uiLanguages) {
         const QString baseName = "clue_" + QLocale(locale).name();
         if (translator.load(":/i18n/" + baseName)) {
             a.installTranslator(&translator);
             break;
         }
     }

    Clue::ConfigureGame b;
    b.exec();

    Clue::MainWindow w(nullptr, b.getGame());
    w.show();
    return a.exec();
}
