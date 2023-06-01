#ifndef EDIT_TABLE_H
#define EDIT_TABLE_H

#include <QWidget>

namespace Ui {
class edit_table;
}

class edit_table : public QWidget
{
    Q_OBJECT

public:
    explicit edit_table(QWidget *parent = nullptr);
    ~edit_table();

private:
    Ui::edit_table *ui;
};

#endif // EDIT_TABLE_H
