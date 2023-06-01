DROP TABLE teacher;

CREATE TABLE teacher (

	teacher_id SERIAL PRIMARY KEY,
	teacher_name TEXT,
	teacher_surname TEXT,
	teacher_faculty INT,
	teacher_last_doc INT,
	FOREIGN KEY (teacher_faculty) REFERENCES faculty(faculty_id),
	FOREIGN KEY (teacher_last_doc) REFERENCES docum_plan(doc_id)

);


DROP FUNCTION check_faculty;

CREATE OR REPLACE FUNCTION check_faculty(t_name TEXT, t_surname TEXT, t_faculty TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
BEGIN
	IF (SELECT faculty_id FROM faculty WHERE faculty_name = t_faculty) IS NOT NULL THEN
		INSERT INTO teacher(teacher_name, teacher_surname, teacher_faculty) VALUES (t_name, t_surname, (SELECT faculty_id FROM faculty WHERE faculty_name = t_faculty));
		RETURN 0;
	END IF;
	RETURN 1;
END; $$

SELECT * FROM check_faculty('Долбнень', 'Лаврушко', 'КБ-4');

SELECT * FROM check_faculty('Виктор', 'Корнеплод', 'КБ-3');
SELECT * FROM faculty;
SELECT * FROM teacher;
SELECT * FROM users;

select * from teacher as hi;

DROP FUNCTION get_tables;

CREATE OR REPLACE FUNCTION get_tables()
RETURNS table("AGA" TEXT, "OGO" TEXT)
LANGUAGE plpgsql AS $$
DECLARE
	elem TEXT;
BEGIN
	CREATE TEMP TABLE rename_rows (
		ru_name TEXT,
		en_name TEXT
	);
	
	FOR elem IN SELECT * FROM (SELECT tablename FROM pg_tables) foo WHERE tablename NOT LIKE 'pg%' AND tablename NOT LIKE 'sql%' ORDER BY tablename ASC
	LOOP
		CASE
			WHEN elem = 'faculty' THEN
				INSERT INTO rename_rows(ru_name, en_name) VALUES ('Факультет', elem);
			WHEN elem = 'docum_plan' THEN
				INSERT INTO rename_rows(ru_name, en_name) VALUES ('В процессе', elem);
			WHEN elem = 'teacher' THEN
				INSERT INTO rename_rows(ru_name, en_name) VALUES ('Преподаватели', elem);
			WHEN elem = 'archive' THEN
				INSERT INTO rename_rows(ru_name, en_name) VALUES ('Архив', elem);
			WHEN elem = 'publisher' THEN
				INSERT INTO rename_rows(ru_name, en_name) VALUES ('Издательства', elem);
			ELSE
				CONTINUE;
				
		END CASE;
	END LOOP;
	
	RETURN QUERY SELECT ru_name, en_name FROM rename_rows;
	DROP TABLE rename_rows;
END; $$

SELECT * FROM get_tables();

DROP TABLE rename_rows;

SELECT * FROM rename_rows;
SELECT * FROM users;
SELECT * FROM faculty;

select * from rename_rows;

SELECT * FROM (SELECT tablename FROM pg_tables) foo WHERE tablename NOT LIKE 'pg%' AND tablename NOT LIKE 'sql%'


SELECT *, pg_tablespace_location(oid) FROM pg_tablespace;




SELECT * FROM teacher;
DELETE FROM teacher WHERE teacher_id = 1;

SELECT * FROM teacher;
SELECT * FROM faculty;
SELECT faculty_id FROM faculty WHERE faculty_name = 't_faculty';
DROP TABLE teacher CASCADE;

CREATE TABLE docum_plan (

	doc_id SERIAL PRIMARY KEY,
	doc_name TEXT,
	last_mod DATE,
	in_process BOOL

);

INSERT INTO teacher(teacher_name, teacher_surname, teacher_faculty) VALUES ('Никита', 'Хукумкин', 1);
DELETE FROM teacher WHERE teacher_id = 4;



CREATE OR REPLACE TRIGGER update_count
AFTER INSERT ON teacher
FOR EACH ROW
EXECUTE PROCEDURE update_faculty();

CREATE OR REPLACE FUNCTION update_faculty()
RETURNS trigger AS $$
DECLARE
	in_id INT;
BEGIN
	in_id = (SELECT teacher_faculty FROM teacher ORDER BY teacher_id DESC LIMIT 1);
	UPDATE faculty SET teacher_count = teacher_count + 1 WHERE faculty_id = in_id;
	RETURN NEW;
END; $$ LANGUAGE plpgsql;



SELECT * FROM faculty;	
SELECT * FROM teacher;

CREATE VIEW archive_view AS SELECT * FROM show_archive();
SELECT * FROM archive_view;

SELECT * FROM docum_plan;

DROP TABLE docum_plan CASCADE;

CREATE TABLE faculty (

	faculty_id SERIAL PRIMARY KEY,
	faculty_name TEXT NOT NULL,

);

ALTER TABLE faculty ADD COLUMN teacher_count INT;

SELECT * FROM teacher;

CREATE TABLE publisher (

	publisher_id SERIAL PRIMARY KEY,
	general_manager TEXT,
	address TEXT,
	pub_name TEXT

);

DROP TABLE publisher CASCADE;

CREATE TABLE archive (

	publication_id SERIAL,
	publication_date DATE,
	pub_id INT,
	publication_name TEXT,
	pub_author INT,
	FOREIGN KEY (pub_author) REFERENCES teacher(teacher_id),
	FOREIGN KEY (pub_id) REFERENCES publisher(publisher_id)

);

DROP TABLE archive;

CREATE OR REPLACE PROCEDURE add_temp(temp_name TEXT, temp_mod DATE, status BOOL)
LANGUAGE plpgsql AS $$
BEGIN
	INSERT INTO docum_plan(doc_name, last_mod, in_process) VALUES (temp_name, temp_mod, status);
END; $$

CREATE OR REPLACE PROCEDURE add_faculty(input_name TEXT)
LANGUAGE plpgsql AS $$
BEGIN
	INSERT INTO faculty(faculty_name) VALUES (input_name);
END; $$

CREATE OR REPLACE PROCEDURE add_document(p_name TEXT, p_auth INT, p_pub INT, p_date DATE)
LANGUAGE sql AS $$
	INSERT INTO archive(publication_name, pub_author, pub_id, publication_date) VALUES (p_name, p_auth, p_pub, p_date);
$$

DROP FUNCTION show_docum_plan;

CREATE OR REPLACE FUNCTION show_docum_plan()
RETURNS table("Название работы" TEXT, "Последнее изменение" DATE, "Закончена ли работа true/false" BOOL)
LANGUAGE sql AS $$
	SELECT doc_name, last_mod, in_process from docum_plan;
$$

SELECT * FROM show_archive();

SELECT * FROM show_docum_plan();

CREATE OR REPLACE FUNCTION show_archive()
RETURNS table("Название работы" TEXT, "Издательство" TEXT, "Дата публикации" DATE)
LANGUAGE sql AS $$
	SELECT ar.publication_name, pub.pub_name, ar.publication_date FROM archive ar
	LEFT JOIN publisher pub ON ar.pub_id = pub.publisher_id;
$$

DROP FUNCTION show_teacher();

CREATE OR REPLACE FUNCTION show_teacher()
RETURNS table("Имя преподавателя" TEXT, "Фамилия преподавателя" TEXT, "Факультет преподавателя" TEXT)
LANGUAGE sql AS $$
	SELECT t.teacher_name, t.teacher_surname, f.faculty_name FROM teacher t
	LEFT JOIN faculty f ON t.teacher_faculty = f.faculty_id;
$$

SELECT * FROM show_teacher();

DROP FUNCTION show_publisher();

CREATE OR REPLACE FUNCTION show_publisher()
RETURNS table("Название издательства" TEXT, "Главный директор" TEXT, "Адрес" TEXT)
LANGUAGE sql AS $$
	SELECT pub_name, address, general_manager FROM publisher;
$$

SELECT * FROM show_publisher();

DROP FUNCTION show_faculty;

CREATE OR REPLACE FUNCTION show_faculty()
RETURNS table("Название кафедры" TEXT, "Количество преподавателей" INT)
LANGUAGE sql AS $$
	SELECT faculty_name, teacher_count FROM faculty;
$$

SELECT * FROM show_faculty();


SELECT * FROM publisher;


DROP FUNCTION show_archive;

SELECT * FROM teacher;
SELECT * FROM faculty;


CALL add_faculty('Марь Иванна');
CALL show_faculty();

SELECT * FROM show_archive();

INSERT INTO publisher(general_manager, address, pub_name) VALUES ('Иванов Иван Иванович', 'Ул. Ивановская д. 228', 'Иваникс');

SELECT * FROM archive;
SELECT * FROM publisher;

SELECT ar.publication_date, ar.publication_publisher, ar.publication_name FROM archive ar;

SELECT * FROM faculty;

INSERT INTO faculty(faculty_name) VALUES ('КБ-4');

INSERT INTO teacher(teacher_name, teacher_faculty) VALUES ('Кашкин Евгений Владимирович', 1);

CALL add_document('Исследование ИИ', 1, 1, '07-06-2015');
CALL add_document('Самое большое название для проверки изменения размеров столбов', 1, 1, '08-07-2016');

DELETE FROM archive WHERE publication_id=2;
SELECT * FROM publisher;
SELECT * FROM teacher;

SELECT rolname FROM pg_roles;

CREATE TABLE users (
	u_name TEXT,
	u_surname TEXT,
	username TEXT,
	passw TEXT,
	user_role TEXT

);
SELECT * FROM users;
DROP TABLE users;


DROP PROCEDURE instert_user;

CREATE ROLE user_1 LOGIN;
DROP ROLE user_1;
SELECT * FROM pg_roles;

CREATE ROLE administrator LOGIN;

DROP FUNCTION strong_insert;

CREATE OR REPLACE FUNCTION strong_insert(user_login TEXT, passwd TEXT, user_role TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
BEGIN
	IF (SELECT COUNT(*) FROM users WHERE username = user_login AND passwd = passw) > 0 THEN
		RETURN 1;
	END IF;
	INSERT INTO users(username, passw, user_role) VALUES (user_login, passwd, user_role);
	RETURN 0;
END; $$

SELECT * FROM strong_insert('яяя', '123', 'asdf');
SELECT * FROM strong_insert('ad', 'ad', 'administrator');

GRANT SELECT ON archive TO user_1;
GRANT SELECT ON publisher TO user_1;

SELECT * FROM users;
DROP FUNCTION user_auth;

CREATE OR REPLACE FUNCTION user_auth(user_login TEXT, passwd TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
DECLARE
	status INT;
BEGIN
	IF (SELECT COUNT(*) FROM users WHERE username = user_login AND passw = passwd) = 1 THEN
		status = 1;
	ELSE
		status = 0;
	END IF;

	
	RETURN status;

END; $$
SELECT * FROM user_auth('e.kashkin', 'hahaha');

DROP FUNCTION role_auth;

CREATE OR REPLACE FUNCTION role_auth(user_name TEXT, u_password TEXT)
RETURNS TEXT
LANGUAGE plpgsql AS $$
BEGIN
	RETURN (SELECT user_role FROM users WHERE username = user_name AND passw = u_password);
END; $$

SELECT * FROM users;

SELECT * FROM role_auth('a', 'a');

SELECT user_role FROM users WHERE username = 'e.kashkin' AND passw = 'hahaha';
CREATE ROLE user_1 LOGIN PASSWORD 'student';

GRANT SELECT ON archive TO user_1;
GRANT SELECT ON publisher TO user_1;
GRANT SELECT ON faculty TO user_1;
GRANT SELECT ON teacher TO user_1;

SELECT * FROM show_archive();

REVOKE SELECT ON archive FROM user_1;
REVOKE SELECT ON publisher FROM user_1;

CREATE ROLE teacher LOGIN PASSWORD 'teacher';
CREATE ROLE administrator LOGIN PASSWORD 'admininstrator';

GRANT user_1 TO teacher;
REVOKE user_1 FROM teacher;

GRANT teacher TO administrator;
REVOKE teacher FROM administrator;

DROP ROLE teacher;
DROP ROLE administrator;

SELECT * FROM users;

