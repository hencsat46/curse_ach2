#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) : QWidget(parent), ui(new Ui::Widget) {
    ui->setupUi(this);
    connect(ui->w_show_db, SIGNAL(clicked()), this, SLOT(show_table()));
    connect(ui->sm_login_button, SIGNAL(clicked()), this, SLOT(login()));
    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");

    db.setHostName("localhost");
    db.setDatabaseName("curse_ach");
    db.setUserName("postgres");
    db.setPassword("forstudy");
    status = db.open();

    qDebug() << this->ui->stackedWidget->currentIndex();

}

Widget::~Widget() {
    delete ui;
}



void Widget::show_table() {

    QSqlQueryModel *sql_model = new QSqlQueryModel();

    if (status) sql_model->setQuery("SELECT * FROM show_archive();");
    this->ui->w_table->horizontalHeader()->setStretchLastSection(true);
    this->ui->w_table->setModel(sql_model);
    this->ui->w_table->resizeColumnsToContents();


}

void Widget::change_widget() {
    this->ui->stackedWidget->setCurrentIndex(1);
}

void Widget::login() {
    QString username = ui->sm_login_edit->text();
    QString password = ui->sm_password_edit->text();
    if (username == "ilya" && password == "forstudy") {
        ui->stackedWidget->setCurrentIndex(0);
    }
}
