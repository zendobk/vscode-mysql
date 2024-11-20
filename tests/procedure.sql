CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  category ENUM('Electronics', 'Books', 'Clothing', 'Home', 'Sports') NOT NULL,
  tags SET('New', 'Sale', 'Popular', 'Limited Edition')
);

DELIMITER //

CREATE PROCEDURE SeedProducts()
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE j INT DEFAULT 0;
  DECLARE bulk_size INT DEFAULT 1000;
  DECLARE total_size INT DEFAULT 100000;
  DECLARE values_str TEXT DEFAULT '';

  WHILE i < total_size DO
    SET j = 0;
    SET values_str = CONCAT('(', QUOTE(CONCAT('Product ', i + j)), ', ', QUOTE('Description for product'), ', ', FLOOR(RAND() * 100) + 1, ')');

    WHILE j < bulk_size - 1 DO
      SET j = j + 1;
      SET values_str = CONCAT(values_str, ', (', QUOTE(CONCAT('Product ', i + j)), ', ', QUOTE('Description for product'), ', ', FLOOR(RAND() * 100) + 1, ')');
    END WHILE;

    SET @insert_query = CONCAT('INSERT INTO products (name, description, price) VALUES ', values_str);
    PREPARE stmt FROM @insert_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET i = i + bulk_size;
  END WHILE;
END //

DELIMITER ;
