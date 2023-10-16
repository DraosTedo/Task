CREATE USER 'user'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON test.* TO 'user'@'%' WITH GRANT OPTION;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    name VARCHAR(64) NOT NULL,
    email VARCHAR(100) NOT NULL
);

INSERT INTO users (id, username, name, email) VALUES (NULL, "test", "Test", "test@test.com");

