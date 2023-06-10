-------------------------------------START CREATE TABLE-----------------------------------------
DROP TABLE teacher;

CREATE TABLE teacher ( ------------------------------------------------------------------------------------------

	teacher_id SERIAL PRIMARY KEY,
	teacher_name TEXT,
	teacher_surname TEXT,
	teacher_faculty INT,
	teacher_last_doc INT,
	teacher_age INT,
	doc_in_process BOOL,
	FOREIGN KEY (teacher_faculty) REFERENCES faculty(faculty_id),
	FOREIGN KEY (teacher_last_doc) REFERENCES docum_plan(doc_id)

);

DROP TABLE student;
CREATE TABLE student ( ------------------------------------------------------------------------------------------

	student_id SERIAL PRIMARY KEY,
	student_name TEXT,
	student_surname TEXT,
	student_faculty INT,
	student_age INT,
	FOREIGN KEY (student_faculty) REFERENCES faculty(faculty_id)

);

DROP TABLE docum_plan;
CREATE TABLE docum_plan ( ------------------------------------------------------------------------------------------

	doc_id SERIAL PRIMARY KEY,
	doc_name TEXT,
	last_mod DATE,
	author_id INT,
	FOREIGN KEY (author_id) REFERENCES teacher(teacher_id)

);

CREATE TABLE faculty (------------------------------------------------------------------------------------------

	faculty_id SERIAL PRIMARY KEY,
	faculty_name TEXT NOT NULL,
);

CREATE TABLE publisher (------------------------------------------------------------------------------------------

	publisher_id SERIAL PRIMARY KEY,
	general_manager TEXT,
	address TEXT,
	pub_name TEXT

);

CREATE TABLE archive (------------------------------------------------------------------------------------------

	publication_id SERIAL,
	publication_date DATE,
	pub_id INT,
	publication_name TEXT,
	pub_author INT,
	FOREIGN KEY (pub_author) REFERENCES teacher(teacher_id),
	FOREIGN KEY (pub_id) REFERENCES publisher(publisher_id)

);

CREATE TABLE users (------------------------------------------------------------------------------------------
	u_name TEXT,
	u_surname TEXT,
	username TEXT,
	passw TEXT,
	user_role TEXT

);
----------------------------------------END CREATE TABLE------------------------------------------



delete from archive where publication_name = 'говно';



-----------------------------------------START SHOW FUNCTIONS-------------------------------------

CREATE OR REPLACE FUNCTION show_student()------------------------------------------------------------------------------------------
RETURNS table("ФИО студента" TEXT, "Возраст" INT, "Факультет" TEXT)
LANGUAGE plpgsql AS $$
BEGIN
	RETURN QUERY SELECT CONCAT(st.student_name, ' ', st.student_surname), st.student_age, f.faculty_name FROM student st
	LEFT JOIN faculty f ON st.student_id = f.faculty_id;
END; $$

SELECT * FROM show_student();


CREATE OR REPLACE FUNCTION show_docum_plan()------------------------------------------------------------------------------------------
RETURNS table("Название работы" TEXT, "Последнее изменение" DATE, "Автор" TEXT)
LANGUAGE sql AS $$
	SELECT doc_name, last_mod, (SELECT CONCAT(teach.teacher_name, ' ', teach.teacher_surname) FROM teacher teach WHERE teach.teacher_id = dp.author_id) FROM docum_plan dp;
$$

SELECT * FROM show_student();


CREATE OR REPLACE FUNCTION show_archive()------------------------------------------------------------------------------------------
RETURNS table("Название работы" TEXT, "Издательство" TEXT, "Дата публикации" DATE, "Автор" TEXT)
LANGUAGE sql AS $$
	SELECT ar.publication_name, pub.pub_name, ar.publication_date, CONCAT(teach.teacher_name, ' ', teach.teacher_surname) FROM archive ar
	LEFT JOIN publisher pub ON ar.pub_id = pub.publisher_id
	LEFT JOIN teacher teach ON ar.pub_author = teach.teacher_id;
$$

SELECT * FROM show_archive();



CREATE OR REPLACE FUNCTION show_publisher()------------------------------------------------------------------------------------------
RETURNS table("Название издательства" TEXT, "Главный директор" TEXT, "Адрес" TEXT)
LANGUAGE sql AS $$
	SELECT pub_name, address, general_manager FROM publisher;
$$

SELECT * FROM show_publisher();


CREATE OR REPLACE FUNCTION show_teacher()------------------------------------------------------------------------------------------
RETURNS table("Имя преподавателя" TEXT, "Фамилия преподавателя" TEXT, "Факультет преподавателя" TEXT)
LANGUAGE sql AS $$
	SELECT t.teacher_name, t.teacher_surname, (SELECT faculty_name FROM faculty f WHERE t.teacher_faculty = f.faculty_id) FROM teacher t;
$$

SELECT * FROM show_teacher();


CREATE OR REPLACE FUNCTION show_faculty()------------------------------------------------------------------------------------------
RETURNS table("Название кафедры" TEXT, "Количество преподавателей" INT)
LANGUAGE sql AS $$
	SELECT faculty_name, teacher_count FROM faculty;
$$

SELECT * FROM show_faculty();



DROP FUNCTION insert_student;

------------------------------------------END SHOW FUNCTIONS-------------------------------------------------






----------------------------------------------START INSERT FUNCTIONS-------------------------------------------


CREATE OR REPLACE FUNCTION insert_student(s_name TEXT, s_surname TEXT, s_faculty INT, s_age INT)
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
	INSERT INTO student(student_name, student_surname, student_faculty, student_age) VALUES (s_name, s_surname, s_faculty, s_age);
END; $$

select * from faculty

CREATE OR REPLACE FUNCTION shit()
RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
	hi INT;
BEGIN
	FOR hi IN 1..100
		LOOP
			--select * from insert_student('a', 'b', 1, 12);
			INSERT INTO faculty(faculty_name, teacher_count) VALUES ('hahahah', 6);
		END LOOP;
	RETURN;
		
		
END; $$

select * from faculty;

SELECT * FROM shit();
call insert_docum_plan('asdf', '1.1.2003', 'Виктор Викторович')
select * from docum_plan;
CREATE OR REPLACE PROCEDURE insert_docum_plan(d_name TEXT, l_mode DATE, t_name TEXT)------------------------------------------------------------------------------------------
LANGUAGE plpgsql AS $$
DECLARE 
	t_id INT;
	status INT;
BEGIN
	t_id = (SELECT teacher_id FROM teacher WHERE CONCAT(teacher_name, ' ', teacher_surname) = t_name);
	IF t_id IS NULL THEN
		status = -1;
	END IF;
	INSERT INTO docum_plan(doc_name, last_mod, author_id) VALUES (d_name, l_mode, t_id);
	CALL upgrade_status(t_id);
	IF status = -1 THEN 
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
	
END; $$

CALL insert_docum_plan('я это я', '08.11.2002', 'Компот Яблочный');
select * from show_docum_plan()
select * from show_teacher()
select * from teacher;



CALL add_faculty('КБ-4');

CREATE OR REPLACE PROCEDURE add_faculty(input_name TEXT)
LANGUAGE plpgsql AS $$
BEGIN
	INSERT INTO faculty(faculty_name, teacher_count) VALUES (input_name, 0);
END; $$





CREATE OR REPLACE PROCEDURE add_document(p_name TEXT, p_auth TEXT, p_pub TEXT, p_date DATE)
LANGUAGE plpsql AS $$
	INSERT INTO archive(publication_name, pub_author, pub_id, publication_date) VALUES (p_name, p_auth, p_pub, p_date);
$$

CREATE OR REPLACE FUNCTION insert_archive(p_name TEXT, p_auth TEXT, p_pub TEXT, p_date DATE)
RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
	author_id INT;
	publ_id INT;
BEGIN
	author_id = (SELECT teacher_id FROM teacher WHERE p_auth = CONCAT(teacher_name, ' ', teacher_surname));
	publ_id = (SELECT publisher_id FROM publisher WHERE p_pub = pub_name);
	INSERT INTO archive(publication_name, pub_author, pub_id, publication_date) VALUES (p_name, author_id, publ_id, p_date);
END; $$
select * from archive
select * from publisher
select * from teacher;

select * from insert_archive('asdlkf', 'Гнилетруп Сухостой', 'Иваникс', '05.11.2003')
SELECT * FROM insert_archive('asdf', 'Виктор Викторович', 'Иваникс', '07.05.2000');

GRANT usage ON SEQUENCE archive_publication_id_seq TO teacher;
GRANT usage ON SEQUENCE docum_plan_doc_id_seq TO teacher;
GRANT usage ON SEQUENCE faculty_faculty_id_seq TO teacher;
GRANT usage ON SEQUENCE publisher_publisher_id_seq TO teacher;

CREATE OR REPLACE FUNCTION strong_insert(user_login TEXT, passwd TEXT, user_role TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
BEGIN
	IF (SELECT COUNT(*) FROM users WHERE username = user_login) > 0 THEN
		RETURN 1;
	END IF;
	INSERT INTO users(username, passw, user_role) VALUES (user_login, passwd, user_role);
	RETURN 0;
END; $$
select * from publisher;
select * from insert_publisher('Виктор Петрович', 'Ул. Кожемякина д.22', 'Звезда');

CREATE OR REPLACE FUNCTION insert_publisher(gen_man TEXT, addr TEXT, p_name TEXT)
RETURNS VOID
LANGUAGE sql AS $$
	INSERT INTO publisher(general_manager, address, pub_name) VALUES (gen_man, addr, p_name);
$$



--------------------------------------------------END INSERT FUNCTIONS----------------------------------------------
select * from update_faculty_func('КБ-4', 'КБ-5');

--------------------------------------------------START UPDATE FUNCTIONS-------------------------------------------------

CREATE OR REPLACE TRIGGER update_count------------------------------------------------------------------------------------------
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

CREATE OR REPLACE FUNCTION update_faculty_func(old_name TEXT, new_name TEXT)------------------------------------------------------------------------------------------
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
	UPDATE faculty SET faculty_name = new_name WHERE faculty_name = old_name;
END; $$






CREATE RULE insert_view AS ON INSERT TO teacher_view DO INSTEAD(
    SELECT insert_teacher(NEW));
	

	
CREATE RULE delete_view AS ON DELETE TO teacher_view DO INSTEAD(
    SELECT delete_teacher(OLD));------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION delete_teacher(old_table teacher_view)------------------------------------------------------------------
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
	DELETE FROM teacher WHERE teacher_name = old_table.teacher_name AND teacher_surname = old_table.teacher_surname AND teacher_age = old_table.teacher_age;
END; $$



select * from teacher;

CREATE OR REPLACE FUNCTION delete_teacher_view(t_name TEXT, t_surname TEXT, f_name TEXT, t_age INT)-------------------------------------------------------------
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
	DELETE FROM teacher_view WHERE t_name = teacher_name AND teacher_surname = t_surname AND f_name = faculty_name AND t_age = teacher_age;
END; $$


CREATE OR REPLACE FUNCTION insert_teacher(new_table teacher_view)
RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
	table_id INT;
BEGIN
	table_id = (SELECT faculty_id FROM faculty WHERE faculty_name = new_table.faculty_name);
	INSERT INTO teacher(teacher_name, teacher_surname, teacher_faculty, teacher_age, doc_in_process)
	VALUES (new_table.teacher_name, new_table.teacher_surname, table_id, new_table.teacher_age, 'false');
END; $$

select * from insert_teacher_view('Негр', 'Плакатов', 'КБ-4', '27');
select * from delete_teacher_view('Негр', 'Плакатов', 'КБ-4', '27');

select * from teacher_view;




CREATE OR REPLACE FUNCTION insert_teacher_view(new_name TEXT, new_surname TEXT, new_faculty TEXT, new_age INT)-----------------------------------------------------------
RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
	table_id INT;
BEGIN
	table_id = (SELECT faculty_id FROM faculty WHERE new_faculty = faculty_name);
	INSERT INTO teacher_view(teacher_name, teacher_surname, faculty_name, teacher_age) VALUES (new_name, new_surname, new_faculty, new_age);
	
END; $$

drop view teacher_view cascade;

SELECT * FROM teacher_view;

CREATE OR REPLACE FUNCTION update_teacher(old_table teacher_view, new_table teacher_view)------------------------------------------------------------------------------------------
RETURNS INT AS $$
DECLARE
	temp_faculty INT;
BEGIN
	UPDATE teacher
		SET teacher_name = new_table.teacher_name,
		teacher_surname = new_table.teacher_surname,
		teacher_age = new_table.teacher_age
		WHERE teacher_id = old_table.teacher_id;
		
	IF new_table.faculty_name IN (SELECT faculty_name FROM faculty) AND new_table.faculty_name IS NOT NULL THEN
		temp_faculty = (SELECT faculty_id FROM faculty WHERE new_table.faculty_name = faculty.faculty_name);
		UPDATE teacher
		SET teacher_faculty = temp_faculty WHERE teacher_id = old_table.teacher_id;
		
	ELSE 
		RETURN -1;
	END IF;	
	RETURN 0;
END; $$
LANGUAGE plpgsql;

select * from teacher_view;

drop function update_teacher_view;

SELECT * FROM update_teacher_view('Гнилетруп', 'Сухостой', 'КБ-6', 'Виктор', 'Деволов', 'КБ-6', 22);
SELECT * FROM update_teacher_view('Компот', 'Яблочный', 'КБ-6', 'Данил', 'Григорьев', 'КБ-4', 23);

CREATE OR REPLACE FUNCTION update_teacher_view(old_name TEXT, old_surname TEXT, old_faculty TEXT, new_name TEXT, new_surname TEXT, new_faculty TEXT, new_age INT)
RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
	table_id INT;
BEGIN
	table_id = (SELECT teacher_id FROM teacher_view WHERE old_name = teacher_name AND teacher_surname = old_surname AND old_faculty = faculty_name);
	UPDATE teacher_view SET teacher_name = new_name, teacher_surname = new_surname, faculty_name = new_faculty, teacher_age = new_age WHERE teacher_id = table_id;
END; $$


CREATE RULE update_view AS ON UPDATE TO teacher_view DO INSTEAD(
    SELECT update_teacher(OLD, NEW));





select * from insert_teacher_view('Пармон', 'Хиджи', )

select * from teacher;
CREATE OR REPLACE PROCEDURE upgrade_status(a_id INT)------------------------------------------------------------------------------------------
LANGUAGE plpgsql AS $$
BEGIN
	UPDATE teacher SET doc_in_process = 'true' WHERE teacher_id = a_id;
END; $$

CREATE OR REPLACE CONSTRAINT TRIGGER upgrade_status_t------------------------------------------------------------------------------------------
BEFORE INSERT ON docum_plan
FOR EACH ROW
EXECUTE PROCEDURE upgrade_status();




CREATE OR REPLACE FUNCTION update_publisher(old_name TEXT, new_name TEXT, new_manager TEXT, new_address TEXT)------------------------------------------------------------------------------------------
RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
	rec RECORD;
	update_cursor CURSOR FOR SELECT general_manager, address, pub_name FROM publisher;
BEGIN
	FOR rec IN update_cursor LOOP
		UPDATE publisher SET pub_name = new_name, general_manager = new_manager, address = new_address WHERE pub_name = old_name;
		EXIT WHEN NOT FOUND;
	END LOOP;
END; $$

CREATE OR REPLACE FUNCTION get_author_id(fio TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
DECLARE
	t_id INT;
BEGIN
	t_id = (SELECT teacher_id FROM teacher WHERE CONCAT(teacher_name, ' ', teacher_surname) = fio);
	IF t_id IS NOT NULL THEN
		RETURN t_id;
	END IF;
	RETURN -1;
END; $$

CREATE OR REPLACE FUNCTION get_publisher()
RETURNS table("Название" TEXT, "id" INT)
LANGUAGE sql AS $$

	SELECT pub_name, publisher_id FROM publisher;
$$
select * from publisher;
SELECT * FROM get_publisher();

drop function update_archive;
CREATE OR REPLACE FUNCTION update_archive(old_name TEXT, new_name TEXT, new_date DATE, new_publisher TEXT, new_author TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
DECLARE
	table_id INT;
	new_publisher_id INT;
	new_author_id INT;
BEGIN
	new_author_id = (SELECT teacher_id FROM teacher WHERE CONCAT(teacher_name, ' ', teacher_surname) = new_author);
	new_publisher_id = (SELECT publisher_id FROM publisher WHERE new_publisher = pub_name);
	IF new_author_id IS NOT NULL AND new_publisher_id IS NOT NULL THEN
		table_id = (SELECT publication_id FROM archive WHERE publication_name = old_name);
		UPDATE archive SET publication_name = new_name, publication_date = new_date, pub_id = new_publisher_id, pub_author = new_author_id WHERE publication_name = old_name;
		RETURN 0;
	END IF;
	RETURN -1;
END; $$



select * from show_archive();
select * from archive;
delete from archive where publication_id = 2;
select * from teacher;
SELECT * FROM update_archive('Работа номер 1', 'Работа номер 2', '07.08.2003', 'Иваникс', 'Гнилетруп Сухостой');

SELECT * FROM show_docum_plan()
drop function update_docum_plan;
CREATE OR REPLACE FUNCTION update_docum_plan(old_author TEXT, new_date DATE, new_name TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
DECLARE
	table_id INT;
	t_id INT;
	new_teacher_id INT;
BEGIN 
	t_id = (SELECT teacher_id FROM teacher WHERE CONCAT(teacher_name, ' ', teacher_surname) = old_author);
	table_id = (SELECT doc_id FROM docum_plan WHERE t_id = author_id);
	IF t_id IS NOT NULL THEN
		UPDATE docum_plan SET doc_name = new_name, last_mod = new_date WHERE doc_id = table_id;
		RETURN 0;
	END IF;
	RETURN -1;
END; $$

select * from update_docum_plan('Компот Яблочный', '12.10.2005', 'А теперь не я');


---------------------------------------------------END UPDATE FUNCTIONS-----------------------------------------------------



-----------------------------------------------------START DELETE FUNCTIONS------------------------------------------------------
CREATE OR REPLACE FUNCTION delete_archive(delete_name TEXT)
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
	DELETE FROM archive WHERE publication_name = delete_name;
END; $$

delete from faculty where faculty_name = 'hahahah'

select * from archive
select * from delete_archive('привет');
select * from 
CREATE OR REPLACE FUNCTION delete_docum_plan(delete_name TEXT)
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
	UPDATE teacher SET doc_in_process = 'false' WHERE (SELECT author_id FROM docum_plan WHERE doc_name = delete_name) = teacher_id;
	DELETE FROM docum_plan WHERE doc_name = delete_name;
END; $$

select * from student;

select * from delete_faculty('КБ-3')





CREATE OR REPLACE FUNCTION delete_faculty(delete_name TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
BEGIN
	IF (SELECT teacher_count FROM faculty WHERE faculty_name = delete_name) > 0 AND (SELECT COUNT(*) FROM student WHERE student_faculty = (SELECT faculty_id FROM faculty WHERE faculty_name = delete_name)) > 0 THEN
		RETURN -1;
	ELSE
		DELETE FROM faculty WHERE faculty_name = delete_name;
		RETURN 0;
	END IF;
END; $$
select * from teacher
CREATE VIEW teacher_view AS SELECT teacher_id, teacher_name, teacher_surname, faculty.faculty_name, teacher_age FROM teacher LEFT JOIN faculty ON faculty.faculty_id = teacher.teacher_faculty;
select * from teacher_view;
drop view teacher_view CASCADE;

select * from delete_publisher('asdf')
SELECT COUNT(*) FROM archive WHERE pub_author = (SELECT publisher_id FROM publisher WHERE pub_name = 'asdf');
select * from publisher;
select * from archive;

CREATE OR REPLACE FUNCTION delete_publisher(delete_name TEXT)
RETURNS INT
LANGUAGE plpgsql AS $$
BEGIN
	IF (SELECT COUNT(*) FROM archive WHERE pub_author = (SELECT publisher_id FROM publisher WHERE pub_name = delete_name)) > 0 THEN
		RETURN -1;
	ELSE
		DELETE FROM publisher WHERE publisher_name = delete_name;
		RETURN 0;
	END IF;
END; $$

select * from docum_plan;

CREATE OR REPLACE FUNCTION delete_teacher(delete_name TEXT, delete_surname TEXT, delete_faculty INT)
RETURNS INT
LANGUAGE plpgsql AS $$
DECLARE
	t_id INT;
BEGIN
	t_id = (SELECT teacher_id FROM teacher WHERE teacher_name = delete_name AND teacher_surname = delete_surname AND teacher_faculty = delete_faculty);
	IF (SELECT COUNT(*) FROM docum_plan WHERE t_id = author_id) > 0 AND (SELECT COUNT(*) FROM archive WHERE t_id = pub_author) > 0 THEN
		RETURN -1;
	ELSE
		UPDATE faculty SET teacher_count = teacher_count - 1 WHERE faculty_id = delete_faculty;
		DELETE FROM teacher WHERE teacher_name = delete_name AND teacher_surname = delete_surname AND teacher_faculty = delete_faculty;
		RETURN 0;
	END IF;
END; $$



CREATE OR REPLACE FUNCTION delete_student(delete_name TEXT, delete_surname TEXT, delete_faculty INT
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
	DELETE FROM student WHERE student_name = delete_name AND student_surname = delete_surname AND student_faculty = delete_faculty;
END; $$





----------------------------------------------------END DELETE FUNCTIONS------------------------------------------------------------


----------------------------------------------------START SUBQUERIES----------------------------------------------------------




---------------------------------------------------------END SUBQUERIES--------------------------------------------------------

---------------------------------------------------------START ROLES---------------------------------------------------

CREATE ROLE teacher LOGIN PASSWORD 'teacher';
CREATE ROLE administrator LOGIN PASSWORD 'administrator';

GRANT user_1 TO teacher;
REVOKE user_1 FROM teacher;

GRANT teacher TO administrator;
REVOKE teacher FROM administrator;

GRANT INSERT ON docum_plan TO teacher;
GRANT UPDATE ON docum_plan TO teacher;
GRANT SELECT ON docum_plan TO teacher;
									  
GRANT SELECT ON archive TO 
GRANT SELECT ON archive, docum_plan, student, teacher, publisher, faculty TO administrator;
GRANT INSERT ON archive, docum_plan, student, teacher, publisher, faculty TO administrator;
GRANT UPDATE ON archive, docum_plan, student, teacher, publisher, faculty TO administrator;
GRANT DELETE ON archive, docum_plan, student, teacher, publisher, faculty TO administrator;
GRANT SELECT ON teacher_view TO administrator;
GRANT UPDATE ON teacher_view TO administrator;
GRANT INSERT ON teacher_view TO administrator;
GRANT DELETE ON teacher_view TO administrator;
CREATE ROLE superuser LOGIN PASSWORD 'forstudy';

GRANT administrator TO superuser;
GRANT INSERT ON users TO superuser;
GRANT UPDATE ON users TO superuser;
GRANT SELECT ON users TO superuser;

select * from users



---------------------------------------------------------END ROLES-----------------------------------------------------









select * from show_archive()











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



INSERT INTO teacher(teacher_name, teacher_surname, teacher_faculty) VALUES ('Никита', 'Хукумкин', 1);
DELETE FROM teacher WHERE teacher_id = 4;







SELECT * FROM faculty;	
SELECT * FROM teacher;

CREATE VIEW archive_view AS SELECT * FROM show_archive();
SELECT * FROM archive_view;

SELECT * FROM docum_plan;

DROP TABLE docum_plan CASCADE;


ALTER TABLE faculty ADD COLUMN teacher_count INT;

SELECT * FROM teacher;



DROP TABLE publisher CASCADE;



DROP TABLE archive;



DROP FUNCTION show_docum_plan;
----------------------------!!!!!!!!!!!!!!!!!!!!---------------------------

SELECT * FROM show_archive();

SELECT * FROM show_docum_plan();

DROP FUNCTION show_archive();


DROP FUNCTION show_teacher();
--------------------------------------------!!!!!!!!!!!!!!!!!!!!!!!----------------------------------------


DROP FUNCTION show_publisher();



DROP FUNCTION show_faculty;




SELECT * FROM publisher;


DROP FUNCTION show_archive;

SELECT * FROM teacher;
SELECT * FROM faculty;



SELECT * FROM teacher_view;

DROP VIEW teacher_view;
SELECT * FROM teacher;
SELECT * FROM faculty;

------------------------------------------------------------------------------

-----------------------------------------------------------------------------

SELECT * FROM docum_plan;

SELECT * FROM show_docum_plan();
DROP FUNCTION insert_docum_plan;




DROP PROCEDURE upgrade_status CASCADE;



DELETE FROM docum_plan WHERE doc_name = 'a';

INSERT INTO docum_plan(doc_name, last_mod, author_id) VALUES ('a', '01-01-2001', 'Никита Хукумкин');
CALL insert_docum_plan('a', '01-01-2001', 'Гнилетруп Тухлогной');
SELECT * FROM docum_plan;
SELECT * FROM teacher;
ALTER TABLE teacher ADD COLUMN doc_in_process BOOL;


SELECT * FROM teacher;

CREATE RULE update_view_temp AS ON UPDATE TO teacher_view DO INSTEAD(
	SELECT temp_f(OLD, NEW));

DROP FUNCTION update_teacher(teacher_view, teacher_view) CASCADE;
DROP RULE update_view_temp ON teacher_view;

CREATE OR REPLACE FUNCTION temp_f (old_t teacher_view, new_t teacher_view)
RETURNS TEXT AS $$
BEGIN
	RETURN new_t.faculty_name;
END; $$
LANGUAGE plpgsql;

DROP FUNCTION get_authors;
CREATE OR REPLACE FUNCTION get_authors()
RETURNS table("ФИО автора" TEXT) AS $$
	SELECT CONCAT(teacher_name, ' ', teacher_surname) FROM teacher;
$$
LANGUAGE sql;

SELECT * FROM get_authors();
SELECT * FROM archive;


DROP FUNCTION is_author();------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_author(author TEXT)
RETURNS INT AS $$
BEGIN
	CASE
		WHEN author IN (SELECT CONCAT(teach.teacher_name, ' ', teach.teacher_surname) AS teacher FROM archive ar
			LEFT JOIN teacher teach ON ar.pub_author = teach.teacher_id) THEN
			RETURN 1;
		ELSE
			RETURN 0;
	END CASE;
END; $$
LANGUAGE plpgsql;

SELECT * FROM is_author('Гнилетруп Тухлогной');


SELECT * FROM show_archive();

DROP RULE update_view ON teacher_view;
	
SELECT * FROM teacher_view;
SELECT * FROM show_teacher();

UPDATE teacher_view SET teacher_name = 'Гнилетруп', teacher_surname = 'Тухлогной' WHERE teacher_id = 1;
UPDATE teacher_view SET faculty_name = 'КБ-4' WHERE teacher_id = 1;
UPDATE teacher_view SET teacher_name = 'Бнилобин' WHERE teacher_id = 2;


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


SELECT * FROM users;
DROP TABLE users;


DROP PROCEDURE instert_user;

CREATE ROLE user_1 LOGIN;
DROP ROLE user_1;
SELECT * FROM pg_roles;

CREATE ROLE administrator LOGIN;

DROP FUNCTION strong_insert;



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
		status = 0;
	ELSE
		status = -1;
	END IF;

	
	RETURN status;

END; $$
SELECT * FROM user_auth('a', 'a');

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

GRANT SELECT ON docum_plan TO administrator;

SELECT * FROM show_archive();
SELECT * FROM archive;

CREATE OR REPLACE FUNCTION show_max()------------------------------------------------------------------------------------------
RETURNS table("Название работы" TEXT, "Издательство" TEXT, "Дата публикации" DATE, "Автор" TEXT)
LANGUAGE plpgsql AS $$
BEGIN
	RETURN QUERY SELECT ar.publication_name, pub.pub_name, ar.publication_date, CONCAT(teach.teacher_name, ' ', teach.teacher_surname) FROM archive ar
	LEFT JOIN publisher pub ON ar.pub_id = pub.publisher_id
	LEFT JOIN teacher teach ON ar.pub_author = teach.teacher_id WHERE ar.publication_date = (SELECT MAX(publication_date) FROM archive);
END; $$	

SELECT * FROM show_max();
SELECT * FROM show_archive();

SELECT * FROM publisher;

CREATE OR REPLACE FUNCTION show_from()------------------------------------------------------------------------------------------
RETURNS table("Название" TEXT, "Адрес" TEXT)
LANGUAGE plpgsql AS $$
BEGIN
	RETURN QUERY SELECT pub_name, address FROM (SELECT * FROM publisher) foo;
END; $$

SELECT * FROM show_from();

REVOKE SELECT ON archive FROM user_1;
REVOKE SELECT ON publisher FROM user_1;



DROP ROLE teacher;
DROP ROLE administrator;

SELECT * FROM users;
SELECT * FROM show_archive();

DROP FUNCTION show_select;
---------------------------------!!!!!!!!!!!!!------------------------------------
CREATE OR REPLACE FUNCTION show_select()------------------------------------------------------------------------------------------
RETURNS table("Название работы" TEXT, "Издательство" TEXT, "Дата публикации" DATE, "Автор" TEXT, "Факультет" TEXT)
LANGUAGE plpgsql AS $$
BEGIN
	RETURN QUERY SELECT ar.publication_name, pub.pub_name, ar.publication_date, CONCAT(teach.teacher_name, ' ', teach.teacher_surname), 
	(SELECT f.faculty_name FROM faculty f WHERE teach.teacher_faculty = f.faculty_id) FROM archive ar
	LEFT JOIN publisher pub ON ar.pub_id = pub.publisher_id
	LEFT JOIN teacher teach ON ar.pub_author = teach.teacher_id;
END; $$

SELECT * FROM show_select();
--SELECT * FROM archive;
select * from users;

select * from student;

CREATE OR REPLACE FUNCTION show_old_student()------------------------------------------------------------------------------------------
RETURNS table("ФИО студента" TEXT, "Факультет студента" TEXT, "Возраст студента" INT)
LANGUAGE plpgsql AS $$
BEGIN
	SELECT CONCAT(s.student_name, ' ', s.student_surname), (SELECT f.faculty_name FROM faculty f WHERE f.faculty_id = s.student_faculty), s.student_age FROM student s WHERE student_age > ALL (SELECT teacher_age FROM teacher);
END; $$

CREATE OR REPLACE FUNCTION show_any_student()
RETURNS table("ФИО студента" TEXT, "Факультет студента" TEXT, "Возраст студента" INT)
LANGUAGE plpgsql AS $$
BEGIN
	RETURN QUERY SELECT CONCAT(s.student_name, ' ', s.student_surname), (SELECT f.faculty_name FROM faculty f WHERE f.faculty_id = s.student_faculty), s.student_age FROM student s WHERE student_age > ANY (SELECT teacher_age FROM teacher);
END; $$

SELECT * FROM show_any_student();

select * from archive

DROP INDEX student_age_index;
DROP INDEX archive_date_index;
DROP INDEX faculty_faculty_index;


SET enable_seqscan = OFF;
SET enable_indexscan = ON;
CREATE INDEX faculty_faculty_index ON faculty USING gin(faculty_name gin_trgm_ops);

EXPLAIN analyse select faculty_name from faculty where faculty_name LIKE 'a';

CREATE INDEX student_age_index ON student USING brin(student_age);------------------------------------------------------------------------------------------
CREATE INDEX archive_date_index ON archive USING btree(publication_date);------------------------------------------------------------------------------------------
CREATE EXTENSION pg_trgm;
------------------------------------------------------------------------------------------

select * from faculty;
drop function having_function;
CREATE OR REPLACE FUNCTION having_function()
RETURNS table("Название факультета" TEXT, "Количество преподавателей" INT)
LANGUAGE plpgsql AS $$
BEGIN
	RETURN QUERY SELECT faculty_name, max(teacher_count) FROM faculty GROUP BY faculty_name HAVING max(teacher_count) > 3;

END; $$

SELECT * FROM having_function();

select * from student



DROP FUNCTION update_teacher(TEXT, TEXT);


SELECT update_teacher()

CREATE OR REPLACE FUNCTION get_faculties()
RETURNS table("Название" TEXT)
LANGUAGE sql AS $$
	SELECT faculty_name FROM faculty;
$$



