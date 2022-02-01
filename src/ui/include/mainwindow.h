#ifndef CLUE_MAINWINDOW_H
#define CLUE_MAINWINDOW_H

#include <QMainWindow>

namespace Clue {

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = nullptr);

signals:

};

} // namespace Clue

#endif // CLUE_MAINWINDOW_H
