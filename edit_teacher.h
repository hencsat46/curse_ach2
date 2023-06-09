#ifndef EDIT_TEACHER_H
#define EDIT_TEACHER_H

#include <QWidget>

namespace Ui {
class Edit_teacher;
}

class Edit_teacher : public QWidget
{
    Q_OBJECT

public:
    explicit Edit_teacher(QWidget *parent = nullptr);
    ~Edit_teacher();

private:
    Ui::Edit_teacher *ui;
};

#endif // EDIT_TEACHER_H
