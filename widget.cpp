#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) : QWidget(parent), ui(new Ui::Widget) {
    ui->setupUi(this);
    shit_config();



}

void Widget::shit_config() {
    connect(ui->w_show_db, SIGNAL(clicked()), this, SLOT(show_table()));
    connect(ui->sm_login_button, SIGNAL(clicked()), this, SLOT(login()));
    connect(ui->r_box_role, SIGNAL(currentIndexChanged(int)), this, SLOT(box_changed()));
    connect(ui->sm_reg_link, SIGNAL(clicked()), this, SLOT(reg_link()));
    connect(ui->r_auth_link, SIGNAL(clicked()), this, SLOT(auth_link()));
    connect(ui->r_registration_button, SIGNAL(clicked()), this, SLOT(registration()));
    connect(ui->w_disconnect_button, SIGNAL(clicked()), this, SLOT(db_disconnect()));
    connect(ui->stackedWidget, SIGNAL(currentChanged(int)), this, SLOT(get_tables()));

    set_color(ui->r_wcode_label, Qt::red);
    set_color(ui->r_wdata_label, Qt::red);
    set_color(ui->sm_wdata_label, Qt::red);

    ui->r_box_role->setCurrentIndex(0);
    ui->r_wcode_label->hide();
    ui->r_wdata_label->hide();
    ui->r_code_widget->hide();
    ui->sm_wdata_label->hide();
    ui->r_faculty_widget->hide();
    ui->stackedWidget->setCurrentIndex(1);
    ui->sm_password_edit->setEchoMode(QLineEdit::Password);
    ui->r_password_edit->setEchoMode(QLineEdit::Password);

}

Widget::~Widget() {
    delete ui;
}

void Widget::set_color(QLabel *local_label, QColor color) {
    QPalette palette = local_label->palette();
    palette.setColor(local_label->foregroundRole(), color);
    local_label->setPalette(palette);
}

void Widget::get_tables() {

    if (ui->stackedWidget->currentIndex() != 0) return;



    qDebug() << "table";
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "superuser_connection");
        db.setHostName("localhost");
        db.setDatabaseName("curse_ach");
        db.setUserName("postgres");
        db.setPassword("forstudy");
        bool status = db.open();
        table_list = QList<QString>();
        qDebug() << status;
        if (status) {
            QSqlQuery query = QSqlQuery(db);
            query.exec("SELECT * FROM get_tables();");
            QString elem, elem_table;
            while (query.next()) {
                elem = query.value(0).toString();
                elem_table = query.value(1).toString();
                ui->w_tables_box->addItem(elem);
                table_list.append(elem_table);
            }
        }


    }


    close_db("superuser_connection");
    qDebug() << "end table";
    qDebug() << table_list[0];

}

void Widget::show_table() {

    QString connection_name = role + "_connection";
    {

    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", connection_name);
    db.setHostName("localhost");
    db.setDatabaseName("curse_ach");
    db.setUserName("user_1");
    db.setPassword("user_1");

    qDebug() << role;

    bool status = db.open();

    qDebug() << db.isOpen();

    sql_model = new QSqlQueryModel();
    if (status) sql_model->setQuery("SELECT * FROM show_archive();", db);

    qDebug() << sql_model->lastError();

    this->ui->w_table->horizontalHeader()->setStretchLastSection(true);
    this->ui->w_table->setModel(sql_model);
    this->ui->w_table->resizeColumnsToContents();

    }

    //close_mode_connection(connection_name);

}

void Widget::close_mode_connection(QString connection_name) {
    if (sql_model != nullptr) {
        delete sql_model;
        sql_model = nullptr;
        close_db(connection_name);
        qDebug() << "connection closed\n";
    }
}

void Widget::db_disconnect() {
    if (sql_model != nullptr) {
        delete sql_model;
        sql_model = nullptr;
        close_db("user_connection");
        qDebug() << "connection closed\n";
    }
}

void Widget::close_db(QString connection_name) {
    {
        QSqlDatabase db = QSqlDatabase::database(connection_name);
        db.close();
    }
    QSqlDatabase::removeDatabase(connection_name);
    return;
}


