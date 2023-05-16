#include "widget.h"
#include "ui_widget.h"

void Widget::reg_link() {
    ui->stackedWidget->setCurrentIndex(2);
}

void Widget::registration() {

    QString username = ui->r_login_edit->text();
    QString password = ui->r_password_edit->text();
    QString code = ui->r_code_edit->text();
    int role = ui->r_box_role->currentIndex();
    QString roles[2] = {"user_1", "teacher"};

    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("localhost");
    db.setDatabaseName("curse_ach");
    db.setUserName("postgres");
    db.setPassword("");
    bool status = db.open();
    if (status) {
        QSqlQuery query;
        switch(role) {
        case 0:
            query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'user_1\');");
            qDebug() << "query sent";
            break;
        case 1:
            if (code == "1234") query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'teacher\');");
            else ui->r_wcode_label->show();
            break;
        }


    }


    close_db();


//query.exec("SELECT * FROM strong_insert(\'" + username + "\', \'" + password + "\', \'" + roles[ui->r_box_role->currentIndex()] + "\');");

}

bool Widget::start_db_superuser() {
    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "superuser_connection");
    db.setHostName("localhost");
    db.setDatabaseName("curse_ach");
    db.setUserName("postgres");
    db.setPassword("");
    return db.isOpen();
}
