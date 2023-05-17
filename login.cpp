#include "widget.h"
#include "ui_widget.h"

void Widget::auth_link() {
    ui->stackedWidget->setCurrentIndex(1);
}

void Widget::login() {
    QString username = ui->sm_login_edit->text();
    QString password = ui->sm_password_edit->text();
    if (username == "ilya" && password == "") {
        ui->stackedWidget->setCurrentIndex(0);
    }
}


