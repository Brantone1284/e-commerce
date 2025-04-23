-- ecommerce.sql 

-- Enable strict mode and InnoDB for transactional support
SET sql_mode = 'STRICT_ALL_TABLES';

-- =============================================================
-- Table: brand
-- =============================================================
CREATE TABLE brand (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =============================================================
-- Table: product_category
-- =============================================================
CREATE TABLE product_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =============================================================
-- Table: product
-- =============================================================
CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_id INT,
    category_id INT,
    product_name VARCHAR(100) NOT NULL,
    base_price DECIMAL(10,2) CHECK (base_price >= 0),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================================
-- Table: product_image
-- =============================================================
CREATE TABLE product_image (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(150),
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================================
-- Table: color
-- =============================================================
CREATE TABLE color (
    color_id INT PRIMARY KEY AUTO_INCREMENT,
    color_name VARCHAR(50) NOT NULL UNIQUE,
    hex_value VARCHAR(7) CHECK (hex_value REGEXP '^#[A-Fa-f0-9]{6}$')
) ENGINE=InnoDB;

-- =============================================================
-- Table: size_category
-- =============================================================
CREATE TABLE size_category (
    size_category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- =============================================================
-- Table: size_option
-- =============================================================
CREATE TABLE size_option (
    size_id INT PRIMARY KEY AUTO_INCREMENT,
    size_category_id INT,
    size_value VARCHAR(20) NOT NULL,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================================
-- Table: product_item
-- =============================================================
CREATE TABLE product_item (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    color_id INT,
    size_id INT,
    price DECIMAL(10,2) CHECK (price >= 0),
    stock_quantity INT CHECK (stock_quantity >= 0),
    sku VARCHAR(100) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(color_id) ON DELETE SET NULL,
    FOREIGN KEY (size_id) REFERENCES size_option(size_id) ON DELETE SET NULL,
    CONSTRAINT unique_product_variation UNIQUE(product_id, color_id, size_id)
) ENGINE=InnoDB;

-- =============================================================
-- Table: product_variation
-- =============================================================
CREATE TABLE product_variation (
    variation_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    variation_type ENUM('color', 'size', 'material', 'other') NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================================
-- Table: attribute_category
-- =============================================================
CREATE TABLE attribute_category (
    attribute_category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- =============================================================
-- Table: attribute_type
-- =============================================================
CREATE TABLE attribute_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name ENUM('text', 'number', 'boolean', 'date') NOT NULL
) ENGINE=InnoDB;

-- =============================================================
-- Table: product_attribute
-- =============================================================
CREATE TABLE product_attribute (
    attribute_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    attribute_category_id INT,
    type_id INT,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id),
    FOREIGN KEY (type_id) REFERENCES attribute_type(type_id),
    CONSTRAINT unique_product_attribute UNIQUE(product_id, attribute_name)
) ENGINE=InnoDB;
