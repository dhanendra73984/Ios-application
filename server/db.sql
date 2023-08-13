CREATE DATABASE mobiles_db;
USE mobiles_db;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS mobiles;
DROP TABLE IF EXISTS orders;


CREATE TABLE user(
    id INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(20),
    lastName VARCHAR(20),
    email VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100),
    mobile VARCHAR(15),
    profileImage VARCHAR(100),
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE userAddress (
    id INT PRIMARY KEY AUTO_INCREMENT,
    userId INT,
    city VARCHAR(100),
    state VARCHAR(100),
    zipcode VARCHAR(100),
    country VARCHAR(100),
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(30),
    description VARCHAR(1000),
    company VARCHAR(20),
    price DECIMAL(10,2),
    image VARCHAR(200),
    createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cart (
    id INT PRIMARY KEY AUTO_INCREMENT,
    userId INT,
    productId INT,
    quantity INT,
    price DECIMAL(10, 2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE userOrder (
    id INT PRIMARY KEY AUTO_INCREMENT,
    userId INT,
    totalPrice DECIMAL(10, 2),
    orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orderDetails (
    id INT PRIMARY KEY AUTO_INCREMENT,
    orderId INT,
    productId INT,
    price DECIMAL(10, 2),
    quantity INT,
    orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

