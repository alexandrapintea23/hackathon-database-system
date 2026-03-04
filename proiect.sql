--BEGIN EXECUTE IMMEDIATE 'DROP TABLE evaluations PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
--BEGIN EXECUTE IMMEDIATE 'DROP TABLE ideas PURGE';       EXCEPTION WHEN OTHERS THEN NULL; END;
--BEGIN EXECUTE IMMEDIATE 'DROP TABLE teams PURGE';       EXCEPTION WHEN OTHERS THEN NULL; END;
--BEGIN EXECUTE IMMEDIATE 'DROP TABLE judges PURGE';      EXCEPTION WHEN OTHERS THEN NULL; END;
--BEGIN EXECUTE IMMEDIATE 'DROP TABLE participants PURGE';EXCEPTION WHEN OTHERS THEN NULL; END;
--BEGIN EXECUTE IMMEDIATE 'DROP TABLE themes PURGE';      EXCEPTION WHEN OTHERS THEN NULL; END;

/*CREATE TABLE themes (
  theme_id   NUMBER PRIMARY KEY,
  theme_name VARCHAR2(100) NOT NULL,
  CONSTRAINT uq_theme_name UNIQUE (theme_name)
);*/

/*CREATE TABLE participants (
  participant_id NUMBER PRIMARY KEY,
  nume           VARCHAR2(100) NOT NULL,
  prenume        VARCHAR2(100) NOT NULL,
  nr_tel         VARCHAR2(30),
  email          VARCHAR2(320) NOT NULL,
  studii         VARCHAR2(100),
  CONSTRAINT uq_part_email UNIQUE (email)
);*/

/*CREATE TABLE teams (
  team_id     NUMBER PRIMARY KEY,
  team_name   VARCHAR2(120) NOT NULL,
  leader_id   NUMBER NOT NULL,
  theme_id    NUMBER NOT NULL,
  score       NUMBER(4,2) DEFAULT 0 NOT NULL,
  CONSTRAINT uq_team_name UNIQUE (team_name),
  CONSTRAINT fk_team_leader FOREIGN KEY (leader_id) REFERENCES participants(participant_id),
  CONSTRAINT fk_team_theme  FOREIGN KEY (theme_id)  REFERENCES themes(theme_id),
  CONSTRAINT chk_team_score CHECK (score BETWEEN 0 AND 10)
);*/

/*CREATE TABLE ideas (
  idea_id      NUMBER PRIMARY KEY,
  team_id      NUMBER NOT NULL,
  theme_id     NUMBER NOT NULL,
  title        VARCHAR2(200) NOT NULL,
  description  VARCHAR2(1000) NOT NULL,
  software     VARCHAR2(200) NOT NULL,
  CONSTRAINT fk_idea_team  FOREIGN KEY (team_id)  REFERENCES teams(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_idea_theme FOREIGN KEY (theme_id) REFERENCES themes(theme_id)
);*/

/*CREATE TABLE judges (
  judge_id   NUMBER PRIMARY KEY,
  full_name  VARCHAR2(200) NOT NULL,
  email      VARCHAR2(320) NOT NULL,
  CONSTRAINT uq_judge_email UNIQUE (email)
);*/

/*CREATE TABLE evaluations (
  eval_id   NUMBER PRIMARY KEY,
  judge_id  NUMBER NOT NULL,
  team_id   NUMBER NOT NULL,
  score     NUMBER(4,2) NOT NULL,
  CONSTRAINT fk_ev_judge FOREIGN KEY (judge_id) REFERENCES judges(judge_id),
  CONSTRAINT fk_ev_team  FOREIGN KEY (team_id)  REFERENCES teams(team_id),
  CONSTRAINT chk_ev_score CHECK (score BETWEEN 0 AND 10),
  CONSTRAINT uq_ev_judge_team UNIQUE (judge_id, team_id)
);*/

--ALTER TABLE participants ADD (github_profile VARCHAR2(300));

--RENAME themes TO themes_tmp;

--RENAME themes_tmp TO themes;

--TRUNCATE TABLE evaluations;

--CREATE TABLE test_drop (id NUMBER);

--DROP TABLE test_drop PURGE;


SELECT table_name
FROM user_tables
WHERE table_name IN ('THEMES','PARTICIPANTS','TEAMS','IDEAS','JUDGES','EVALUATIONS')
ORDER BY table_name;

SELECT column_id, column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'THEMES'
ORDER BY column_id;

SELECT column_id, column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'PARTICIPANTS'
ORDER BY column_id;

SELECT column_id, column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'TEAMS'
ORDER BY column_id;

SELECT column_id, column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'IDEAS'
ORDER BY column_id;

SELECT column_id, column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'JUDGES'
ORDER BY column_id;

SELECT column_id, column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'EVALUATIONS'
ORDER BY column_id;

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'THEMES';

SELECT constraint_name, constraint_type
FROM user_constraints

WHERE table_name = 'PARTICIPANTS';

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'TEAMS';

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'IDEAS';

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'JUDGES';

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'EVALUATIONS';

CREATE OR REPLACE VIEW v_teams_details AS
SELECT 
    t.team_id,
    t.team_name,
    p.nume || ' ' || p.prenume AS leader_name,
    th.theme_name,
    t.score
FROM teams t
JOIN participants p ON p.participant_id = t.leader_id
JOIN themes th ON th.theme_id = t.theme_id;


CREATE OR REPLACE VIEW v_team_scores AS
SELECT
    t.team_id,
    t.team_name,
    COUNT(e.eval_id) AS nr_evaluari,
    AVG(e.score)     AS medie_note
FROM teams t
LEFT JOIN evaluations e ON e.team_id = t.team_id
GROUP BY t.team_id, t.team_name;

SELECT view_name
FROM user_views
WHERE view_name IN ('V_TEAMS_DETAILS','V_TEAM_SCORES')
ORDER BY view_name;

BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW v_team_scores';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;

SELECT view_name
FROM user_views
WHERE view_name = 'V_TEAM_SCORES';

CREATE SEQUENCE seq_participant_id
START WITH 1
INCREMENT BY 1
NOCACHE;

SELECT sequence_name
FROM user_sequences
WHERE sequence_name = 'SEQ_PARTICIPANT_ID';

ALTER SEQUENCE seq_participant_id INCREMENT BY 5;

DROP SEQUENCE seq_participant_id;

SELECT sequence_name
FROM user_sequences
WHERE sequence_name = 'SEQ_PARTICIPANT_ID';

CREATE SYNONYM teams_syn FOR teams;

SELECT synonym_name, table_name
FROM user_synonyms
WHERE synonym_name = 'TEAMS_SYN';

DROP SYNONYM teams_syn;

SELECT synonym_name
FROM user_synonyms
WHERE synonym_name = 'TEAMS_SYN';

CREATE INDEX idx_part_nume ON participants(nume);

SELECT index_name, table_name
FROM user_indexes
WHERE table_name = 'PARTICIPANTS';

DROP INDEX idx_part_nume;

SELECT index_name
FROM user_indexes
WHERE index_name = 'IDX_PART_NUME';

-- 1) THEMES
INSERT INTO themes (theme_id, theme_name) VALUES (1, 'AI Innovations');
INSERT INTO themes (theme_id, theme_name) VALUES (2, 'Green Energy');
INSERT INTO themes (theme_id, theme_name) VALUES (3, 'Smart Cities');
INSERT INTO themes (theme_id, theme_name) VALUES (4, 'Healthcare Tech');
INSERT INTO themes (theme_id, theme_name) VALUES (5, 'Education & Learning');

-- 2) PARTICIPANTS
INSERT INTO participants (participant_id, nume, prenume, nr_tel, email, studii)
VALUES (1, 'Popescu', 'Andrei', '0711111111', 'andrei.popescu@gmail.com', 'Licenta');


INSERT INTO participants (participant_id, nume, prenume, nr_tel, email, studii)
VALUES (2, 'Ionescu', 'Maria', '0722222222', 'maria.ionescu@gmail.com', 'Master');

INSERT INTO participants (participant_id, nume, prenume, nr_tel, email, studii)
VALUES (3, 'Georgescu', 'Alex', '0733333333', 'alex.georgescu@gmail.com', 'Licenta');

INSERT INTO participants (participant_id, nume, prenume, nr_tel, email, studii)
VALUES (4, 'Dumitrescu', 'Ioana', '0744444444', 'ioana.dumitrescu@gmail.com', 'Master');

INSERT INTO participants (participant_id, nume, prenume, nr_tel, email, studii)
VALUES (5, 'Marinescu', 'Radu', '0755555555', 'radu.marinescu@gmail.com', 'Doctorat');

-- 3) TEAMS (are FK spre participants + themes)
INSERT INTO teams (team_id, team_name, leader_id, theme_id, score)
VALUES (1, 'HackMasters', 1, 1, 9.20);

INSERT INTO teams (team_id, team_name, leader_id, theme_id, score)
VALUES (2, 'GreenFuture', 2, 2, 8.75);

INSERT INTO teams (team_id, team_name, leader_id, theme_id, score)
VALUES (3, 'CityCoders', 3, 3, 9.00);

INSERT INTO teams (team_id, team_name, leader_id, theme_id, score)
VALUES (4, 'HealthTechX', 4, 4, 8.90);

INSERT INTO teams (team_id, team_name, leader_id, theme_id, score)
VALUES (5, 'EduSmart', 5, 5, 9.40);

-- 4) IDEAS (are FK spre teams + themes)
INSERT INTO ideas (idea_id, team_id, theme_id, title, description, software)
VALUES (1, 1, 1, 'Smart Mentor', 'Aplicatie AI pentru mentorat la hackathon.', 'Python, FastAPI');

INSERT INTO ideas (idea_id, team_id, theme_id, title, description, software)
VALUES (2, 2, 2, 'Green Tracker', 'Monitorizarea consumului de energie verde.', 'Java, Spring');

INSERT INTO ideas (idea_id, team_id, theme_id, title, description, software)
VALUES (3, 3, 3, 'CityFlow', 'Optimizarea traficului urban inteligent.', 'Node.js, React');

INSERT INTO ideas (idea_id, team_id, theme_id, title, description, software)
VALUES (4, 4, 4, 'HealthAI', 'Asistent medical bazat pe inteligenta artificiala.', 'Python, TensorFlow');

INSERT INTO ideas (idea_id, team_id, theme_id, title, description, software)
VALUES (5, 5, 5, 'EduPlatform', 'Platforma educationala interactiva.', 'Angular, Firebase');


-- 5) JUDGES
INSERT INTO judges (judge_id, full_name, email)
VALUES (1, 'Dr. Mihai Stan', 'mihai.stan@uvt.ro');

INSERT INTO judges (judge_id, full_name, email)
VALUES (2, 'Prof. Ana Pop', 'ana.pop@uvt.ro');

INSERT INTO judges (judge_id, full_name, email)
VALUES (3, 'Dr. Radu Iliescu', 'radu.iliescu@uvt.ro');

INSERT INTO judges (judge_id, full_name, email)
VALUES (4, 'Conf. Ioan Matei', 'ioan.matei@uvt.ro');

INSERT INTO judges (judge_id, full_name, email)
VALUES (5, 'Dr. Elena Varga', 'elena.varga@uvt.ro');


-- 6) EVALUATIONS (are FK spre judges + teams)
INSERT INTO evaluations (eval_id, judge_id, team_id, score)
VALUES (1, 1, 1, 9.50);

INSERT INTO evaluations (eval_id, judge_id, team_id, score)
VALUES (2, 2, 2, 8.80);

INSERT INTO evaluations (eval_id, judge_id, team_id, score)
VALUES (3, 3, 3, 9.10);

INSERT INTO evaluations (eval_id, judge_id, team_id, score)
VALUES (4, 4, 4, 8.95);

INSERT INTO evaluations (eval_id, judge_id, team_id, score)
VALUES (5, 5, 5, 9.60);

COMMIT;

UPDATE teams
SET score = 9.60
WHERE team_id = 1;

UPDATE participants
SET nr_tel = '0799999999'
WHERE participant_id = 2;

COMMIT;

DELETE FROM evaluations
WHERE eval_id = 1;

COMMIT;

DELETE FROM ideas
WHERE idea_id = 1;

COMMIT;

DELETE FROM teams
WHERE team_id = 1;

COMMIT;

SELECT * FROM teams;


MERGE INTO themes t
USING (
    SELECT 10 AS theme_id, 'Health Tech' AS theme_name FROM dual
) s
ON (t.theme_id = s.theme_id)
WHEN MATCHED THEN
  UPDATE SET t.theme_name = s.theme_name
WHEN NOT MATCHED THEN
  INSERT (theme_id, theme_name)
  VALUES (s.theme_id, s.theme_name);

COMMIT;

SELECT *
FROM themes
WHERE theme_id = 10;


--verificam daca exista date in tabel pentru inceput 
SELECT theme_id, theme_name
FROM themes
ORDER BY theme_id;

SELECT participant_id, nume, prenume, email, studii
FROM participants
ORDER BY participant_id; --vezi toti participantii 

SELECT participant_id, nume, prenume, email
FROM participants
WHERE studii = 'Master'; --arata doar participantii cu studii master 

SELECT
    t.team_id,
    t.team_name,
    p.nume || ' ' || p.prenume AS leader_name,
    th.theme_name,
    t.score
FROM teams t
JOIN participants p ON p.participant_id = t.leader_id
JOIN themes th ON th.theme_id = t.theme_id
ORDER BY t.score DESC; --select cu join 

SELECT
    t.team_id,
    t.team_name,
    COUNT(e.eval_id) AS nr_evaluari,
    ROUND(AVG(e.score), 2) AS medie_note
FROM teams t
LEFT JOIN evaluations e ON e.team_id = t.team_id
GROUP BY t.team_id, t.team_name
ORDER BY medie_note DESC; --afiseaza cate evaluari are fiecare echipa si media notelor


--interogarile 
SELECT
    t.team_id,
    t.team_name,
    COUNT(e.eval_id) AS nr_evaluari,
    ROUND(AVG(e.score), 2) AS medie_note
FROM teams t
JOIN evaluations e ON e.team_id = t.team_id
GROUP BY t.team_id, t.team_name
HAVING COUNT(e.eval_id) >= 1
ORDER BY medie_note DESC;


SELECT
    th.theme_id,
    th.theme_name,
    COUNT(t.team_id) AS nr_echipe,
    ROUND(AVG(t.score), 2) AS scor_mediu_echipe
FROM themes th
JOIN teams t ON t.theme_id = th.theme_id
GROUP BY th.theme_id, th.theme_name
HAVING COUNT(t.team_id) >= 1
ORDER BY scor_mediu_echipe DESC;


SELECT
    p.participant_id,
    p.nume,
    p.prenume,
    t.team_name,
    t.score
FROM participants p
JOIN teams t ON t.leader_id = p.participant_id
WHERE t.score > (SELECT AVG(score) FROM teams)
ORDER BY t.score DESC;


SELECT
    j.judge_id,
    j.full_name,
    j.email,
    COUNT(e.eval_id) AS nr_evaluari,
    ROUND(AVG(e.score), 2) AS medie_note_date
FROM judges j
JOIN evaluations e ON e.judge_id = j.judge_id
GROUP BY j.judge_id, j.full_name, j.email
HAVING COUNT(e.eval_id) >= 2
   AND AVG(e.score) > 8.5
ORDER BY medie_note_date DESC;


SELECT
    i.idea_id,
    i.title,
    th.theme_name,
    i.software,
    LENGTH(i.description) AS lungime_descriere
FROM ideas i
JOIN themes th ON th.theme_id = i.theme_id
WHERE (LOWER(i.software) LIKE '%python%' OR LOWER(i.software) LIKE '%java%')
  AND LENGTH(i.description) >= 20
ORDER BY lungime_descriere DESC;


CREATE OR REPLACE VIEW v_top_teams_by_avg AS
SELECT
    t.team_id,
    t.team_name,
    COUNT(e.eval_id) AS nr_evaluari,
    ROUND(AVG(e.score), 2) AS medie_note
FROM teams t
JOIN evaluations e ON e.team_id = t.team_id
GROUP BY t.team_id, t.team_name
HAVING COUNT(e.eval_id) >= 2;

SELECT *
FROM v_top_teams_by_avg
ORDER BY medie_note DESC; --ca sa vad rezultatul

SELECT view_name
FROM user_views
WHERE view_name = 'V_TOP_TEAMS_BY_AVG'; --confirmare existenta vedere



CREATE OR REPLACE VIEW v_theme_stats AS
SELECT
    th.theme_id,
    th.theme_name,
    COUNT(t.team_id) AS nr_echipe,
    ROUND(AVG(t.score), 2) AS scor_mediu_echipe
FROM themes th
JOIN teams t ON t.theme_id = th.theme_id
GROUP BY th.theme_id, th.theme_name
HAVING COUNT(t.team_id) >= 1;

SELECT *
FROM v_theme_stats
ORDER BY scor_mediu_echipe DESC;


CREATE OR REPLACE VIEW v_judge_activity AS
SELECT
    j.judge_id,
    j.full_name,
    j.email,
    COUNT(e.eval_id) AS nr_evaluari,
    ROUND(AVG(e.score), 2) AS medie_note_date
FROM judges j
JOIN evaluations e ON e.judge_id = j.judge_id
GROUP BY j.judge_id, j.full_name, j.email
HAVING COUNT(e.eval_id) >= 2
   AND AVG(e.score) > 8.5;

SELECT *
FROM v_judge_activity
ORDER BY medie_note_date DESC;


CREATE OR REPLACE VIEW v_team_eval_rank AS
SELECT
    th.theme_name,
    t.team_id,
    t.team_name,
    t.score,
    DENSE_RANK() OVER (PARTITION BY th.theme_id ORDER BY t.score DESC) AS pozitie_in_tema
FROM teams t
JOIN themes th ON th.theme_id = t.theme_id;

SELECT *
FROM v_team_eval_rank
ORDER BY theme_name, pozitie_in_tema, score DESC;






