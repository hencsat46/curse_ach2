#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) : QWidget(parent), ui(new Ui::Widget) {
    ui->setupUi(this);
    connect(ui->w_show_db, SIGNAL(clicked()), this, SLOT(show_table()));
    connect(ui->sm_login_button, SIGNAL(clicked()), this, SLOT(login()));
    connect(ui->r_box_role, SIGNAL(currentIndexChanged(int)), this, SLOT(box_changed()));
    connect(ui->sm_reg_link, SIGNAL(clicked()), this, SLOT(reg_link()));
    connect(ui->r_auth_link, SIGNAL(clicked()), this, SLOT(auth_link()));
    connect(ui->r_registration_button, SIGNAL(clicked()), this, SLOT(registration()));
    set_color(ui->r_wcode_label, Qt::red);
    set_color(ui->r_wdata_label, Qt::red);
    ui->r_wcode_label->hide();
    ui->r_wdata_label->hide();



    qDebug() << this->ui->stackedWidget->currentIndex();
    ui->r_box_role->setCurrentIndex(0);
    ui->r_code_label_admin->hide();
    ui->r_code_label_teacher->hide();
    ui->r_code_edit->hide();


}

Widget::~Widget() {
    delete ui;
}

void Widget::set_color(QLabel *local_label, QColor color) {
    QPalette palette = local_label->palette();
    palette.setColor(local_label->foregroundRole(), color);
    local_label->setPalette(palette);
}

void Widget::show_table() {
    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("localhost");
    db.setDatabaseName("curse_ach");
    db.setUserName("postgres");
    db.setPassword("forstudy");

    QSqlQueryModel *sql_model = new QSqlQueryModel();
    bool status = db.open();
    if (status) sql_model->setQuery("SELECT * FROM show_archive();");
    this->ui->w_table->horizontalHeader()->setStretchLastSection(true);
    this->ui->w_table->setModel(sql_model);
    this->ui->w_table->resizeColumnsToContents();


}

void Widget::change_widget() {
    this->ui->stackedWidget->setCurrentIndex(1);
}

void Widget::close_db(QString connection_name) {
    {
        QSqlDatabase db = QSqlDatabase::database(connection_name);
        db.close();
    }
    QSqlDatabase::removeDatabase(connection_name);
    return;
}
