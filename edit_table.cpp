#include "edit_table.h"
#include "ui_edit_table.h"

edit_table::edit_table(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::edit_table)
{
    ui->setupUi(this);
}

edit_table::~edit_table()
{
    delete ui;
}
