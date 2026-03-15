-- Задание 3. Функция: увеличение цен на 10% и возврат количества обработанных записей

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    product_name TEXT,
    price NUMERIC
);

-- Пример данных
-- Выполнять один раз после создания таблицы:
INSERT INTO products (product_name, price) VALUES
    ('Товар А', 100.00),
    ('Товар Б', 250.50),
    ('Товар В', 75.00);

-- Функция: перебирает все записи products, увеличивает цену на 10%, обновляет таблицу,
-- возвращает количество обработанных записей.
CREATE OR REPLACE FUNCTION increase_prices_10_percent()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    processed_count INTEGER;
BEGIN
    UPDATE products
    SET price = price * 1.10;
    GET DIAGNOSTICS processed_count = ROW_COUNT;
    RETURN processed_count;
END;
$$;

-- Пример вызова:
-- SELECT increase_prices_10_percent();
