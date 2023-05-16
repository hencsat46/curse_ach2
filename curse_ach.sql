

CREATE TABLE teacher (

	teacher_id SERIAL PRIMARY KEY,
	teacher_name TEXT,
	teacher_faculty INT,
	FOREIGN KEY (teacher_faculty) REFERENCES faculty(faculty_id)
	
);

DROP TABLE teacher;

CREATE TABLE faculty (

	faculty_id SERIAL PRIMARY KEY,
	faculty_name TEXT NOT NULL
	
);


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

CREATE OR REPLACE PROCEDURE add_faculty(input_name TEXT)
LANGUAGE plpgsql AS $$
BEGIN
	INSERT INTO faculty(faculty_name) VALUES (input_name);
END; $$

CREATE OR REPLACE PROCEDURE add_document(p_name TEXT, p_auth INT, p_pub INT, p_date DATE)
LANGUAGE sql AS $$
	INSERT INTO archive(publication_name, pub_author, pub_id, publication_date) VALUES (p_name, p_auth, p_pub, p_date);
$$



CREATE OR REPLACE FUNCTION show_archive()
RETURNS table("Название работы" TEXT, "Издательство" TEXT, "Дата публикации" DATE)
LANGUAGE sql AS $$
	SELECT ar.publication_name, pub.pub_name, ar.publication_date FROM archive ar
	LEFT JOIN publisher pub ON ar.pub_id = pub.publisher_id;
$$

DROP FUNCTION show_archive;


CALL add_faculty('Марь Иванна');
CALL show_faculty();

SELECT * FROM show_archive();

INSERT INTO publisher(general_manager, address, pub_name) VALUES ('Иванов Иван Иванович', 'Ул. Ивановская д. 228', 'Иваникс');

SELECT * FROM archive;
SELECT * FROM publisher;

SELECT ar.publication_date, ar.publication_publisher, ar.publication_name FROM archive ar;

SELECT * FROM faculty;

INSERT INTO faculty(faculty_name) VALUES ('КБ-4');

INSERT INTO teacher(teacher_name, teacher_faculty) VALUES ('Кашкин Евгений Владимирович', 3);

CALL add_document('Исследование ИИ', 1, 1, '07-06-2015');
CALL add_document('Самое большое название для проверки изменения размеров столбов', 1, 1, '08-07-2016');

DELETE FROM archive WHERE publication_id=2;
SELECT * FROM publisher;
SELECT * FROM teacher;

SELECT rolname FROM pg_roles;

CREATE TABLE users (

	username TEXT,
	passw TEXT,
	user_role TEXT

);

CREATE OR REPLACE PROCEDURE insert_user(user_login TEXT, passwd TEXT, user_role TEXT)
LANGUAGE sql AS $$
	INSERT INTO users(username, passw, user_role) VALUES (user_login, passwd, user_role);
$$

CALL insert_user('илья', '1234', 'user_1');

DROP PROCEDURE instert_user;

CREATE ROLE user_1 LOGIN;
DROP ROLE user_1;
SELECT * FROM pg_roles;

CREATE ROLE administrator LOGIN;

CREATE OR REPLACE FUNCTION strong_insert(user_login TEXT, passwd TEXT, user_role TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
BEGIN
	IF (SELECT COUNT(*) FROM users WHERE username = user_login) > 0 THEN
		RETURN 0;
	END IF;
	CALL insert_user(user_login, passwd, user_role);
	RETURN 1;
END; $$

SELECT * FROM strong_insert('яяя', '123', 'asdf');

GRANT SELECT ON archive TO user_1;
GRANT SELECT ON publisher TO user_1;

SELECT * FROM users;


