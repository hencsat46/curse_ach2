#include "edit_teacher.h"
#include "ui_edit_teacher.h"

Edit_teacher::Edit_teacher(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Edit_teacher)
{
    ui->setupUi(this);
}

Edit_teacher::~Edit_teacher()
{
    delete ui;
}
