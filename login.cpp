#include "widget.h"
#include "ui_widget.h"

void Widget::auth_link() {
    ui->stackedWidget->setCurrentIndex(1);
}

void Widget::login() {

    QString username = ui->sm_login_edit->text();
    QString password = ui->sm_password_edit->text();
    QString pre_role;

    if (!username.isEmpty() && !password.isEmpty()) {
        {

        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "superuser_connection_table");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName("superuser");
        db.setPassword("forstudy");
        bool status = db.open();
        qDebug() << "SELECT * FROM user_auth(\'" + username + "\', \'" + password + "\');";
        QSqlQuery query = QSqlQuery(db);
        if (status) {
            query.exec("SELECT * FROM user_auth(\'" + username + "\', \'" + password + "\');");
            query.next();
            pre_role = query.value(0).toString();
            qDebug() << pre_role;
            if (pre_role == "0") {
                query.exec("SELECT * FROM role_auth(\'" + username + "\', \'" + password + "\');");
                query.next();
                role = query.value(0).toString();
                ui->stackedWidget->setCurrentIndex(0);


            } else {
                ui->sm_wdata_label->show();
            }
        }

        }

        close_db("superuser_connection_table");
    }
}

