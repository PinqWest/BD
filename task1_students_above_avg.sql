
CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    full_name TEXT
);

CREATE TABLE IF NOT EXISTS grades (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id),
    subject TEXT,
    grade INTEGER
);

-- 2. Примеры данных (выполнять один раз после создания таблиц):
INSERT INTO students (full_name) VALUES
    ('Иванов Иван Иванович'),
    ('Петрова Мария Сергеевна'),
    ('Сидоров Алексей Петрович'),
    ('Козлова Анна Дмитриевна'),
    ('Николаев Дмитрий Владимирович');

INSERT INTO grades (student_id, subject, grade) VALUES
    (1, 'Математика', 5),
    (1, 'Физика', 4),
    (1, 'Информатика', 5),
    (2, 'Математика', 4),
    (2, 'Физика', 4),
    (2, 'Информатика', 5),
    (3, 'Математика', 3),
    (3, 'Физика', 3),
    (3, 'Информатика', 4),
    (4, 'Математика', 5),
    (4, 'Физика', 5),
    (4, 'Информатика', 5),
    (5, 'Математика', 2),
    (5, 'Физика', 3),
    (5, 'Информатика', 3);

-- 3. Табличная функция get_students_above_avg(min_avg_grade NUMERIC)
--    Вход: min_avg_grade — порог по среднему баллу.
--    Выход: таблица (student_id, full_name, avg_grade) только для студентов
--           со средним баллом выше min_avg_grade.
CREATE OR REPLACE FUNCTION get_students_above_avg(min_avg_grade NUMERIC)
RETURNS TABLE (
    student_id INTEGER,
    full_name TEXT,
    avg_grade NUMERIC
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        s.id AS student_id,
        s.full_name,
        ROUND(AVG(g.grade)::NUMERIC, 2) AS avg_grade
    FROM students s
    INNER JOIN grades g ON g.student_id = s.id
    GROUP BY s.id, s.full_name
    HAVING AVG(g.grade) > min_avg_grade
    ORDER BY avg_grade DESC;
$$;

-- Пример вызова (подставьте свой минимальный средний балл, например 4.0):
-- SELECT * FROM get_students_above_avg(4.0);
