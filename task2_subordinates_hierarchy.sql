-- Задание 2. Рекурсивная функция: иерархия подчинённых
-- Таблица сотрудников с ссылкой на руководителя

CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager_id INTEGER REFERENCES employees(id)
);

-- Пример данных (иерархия)
INSERT INTO employees (name, manager_id) VALUES
    ('Директор', NULL),           -- 1, верхний уровень
    ('Зам. по продажам', 1),      -- 2
    ('Зам. по разработке', 1),    -- 3
    ('Менеджер А', 2),            -- 4
    ('Менеджер Б', 2),            -- 5
    ('Тимлид', 3),                -- 6
    ('Разработчик 1', 6),         -- 7
    ('Разработчик 2', 6),         -- 8
    ('Стажёр', 7)                 -- 9
ON CONFLICT DO NOTHING;

-- Функция: все подчинённые указанного сотрудника (включая косвенных)
-- Параметр: id сотрудника. Возвращает его самого (level 0) и всех подчинённых по иерархии.
CREATE OR REPLACE FUNCTION get_subordinates_hierarchy(start_employee_id INTEGER)
RETURNS TABLE (
    employee_id INTEGER,
    employee_name VARCHAR,
    level INTEGER
)
LANGUAGE sql
STABLE
AS $$
    WITH RECURSIVE subs AS (
        -- Якорь: сам сотрудник (уровень 0)
        SELECT id AS employee_id, name AS employee_name, 0 AS level
        FROM employees
        WHERE id = start_employee_id

        UNION ALL

        -- Рекурсия: все, чей руководитель уже в результате
        SELECT e.id, e.name, s.level + 1
        FROM employees e
        INNER JOIN subs s ON e.manager_id = s.employee_id
    )
    SELECT subs.employee_id, subs.employee_name, subs.level
    FROM subs
    ORDER BY subs.level, subs.employee_id;
$$;

-- Пример вызова: все подчинённые сотрудника с id = 1 (включая его самого)
-- SELECT * FROM get_subordinates_hierarchy(1);
