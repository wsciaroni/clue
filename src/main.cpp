#include "mainwindow.h"
#include "clue/game.h"
#include "configuregame.h"

#include <QApplication>
#include <QLocale>
#include <QTranslator>

#include <glog/logging.h>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    google::InitGoogleLogging(argv[0]);
    FLAGS_log_dir = "./output/";
    LOG(INFO) << "Applicatino Initialized";
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
    LOG(INFO) << "Game configured, transitioning to main window";
    Clue::MainWindow w(nullptr, b.getGame());
    w.show();
    return a.exec();
}
