
CREATE TABLE REGION (
    id_region INTEGER PRIMARY KEY,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE COMMUNE (
    id_region INTEGER NOT NULL,
	id_commune INTEGER NOT NULL,
    commune VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_commune, id_region),
    FOREIGN KEY (id_region) REFERENCES REGION(id_region)
);

CREATE TABLE NEIGHBORHOOD_BOARD (
    id_neighborhood_board INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    create_date DATE NOT NULL,
    enabled BOOLEAN NOT NULL,
	id_region INTEGER NOT NULL,
    id_commune INTEGER NOT NULL,
	cellphone VARCHAR(15) NOT NULL, 
	email VARCHAR(100) NOT NULL,
	url_signature VARCHAR(100) NOT NULL, 
    FOREIGN KEY (id_commune, id_region) REFERENCES COMMUNE(id_commune, id_region)
);

CREATE TABLE TYPE_USER (
    id_type_user INTEGER PRIMARY KEY,
    type_user VARCHAR(50) NOT NULL
);

CREATE TABLE USERS (
    rut VARCHAR(10) PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL, 
    second_name VARCHAR(50),
    first_surname VARCHAR(50) NOT NULL,
    second_surname VARCHAR(50),
    birthdate DATE NOT NULL,
    email VARCHAR(100) NOT NULL,
	password VARCHAR(50) NOT NULL, 
    address VARCHAR(100) NOT NULL,
    address_verification_url VARCHAR(200),
	cellphone VARCHAR(15) NOT NULL
);

CREATE TABLE STATUS (
    id_status INTEGER PRIMARY KEY,
    status VARCHAR(50) NOT NULL
);


CREATE TABLE BANK_ACCOUNT (
	id_neighborhood_board INTEGER NOT NULL,
    id_bank_account  INTEGER GENERATED ALWAYS AS IDENTITY,
    bank VARCHAR(50) NOT NULL,
    account_number VARCHAR(20),
    rut VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
	PRIMARY KEY (id_neighborhood_board, id_bank_account),
    FOREIGN KEY (id_neighborhood_board) REFERENCES NEIGHBORHOOD_BOARD(id_neighborhood_board)
);


CREATE TABLE USER_NEIGHBORHOOD_BOARD (
    id_neighborhood_board INTEGER NOT NULL,
	rut VARCHAR(10) NOT NULL,
	id_type_user INTEGER NOT NULL,
    emergency_enabled BOOLEAN NOT NULL,
    creation_date DATE NOT NULL,
    enabled BOOLEAN NOT NULL,
    id_status INTEGER NOT NULL,
    PRIMARY KEY (rut, id_neighborhood_board, id_type_user),
    FOREIGN KEY (rut) REFERENCES USERS(rut),
    FOREIGN KEY (id_neighborhood_board) REFERENCES NEIGHBORHOOD_BOARD(id_neighborhood_board),
    FOREIGN KEY (id_status) REFERENCES STATUS(id_status)
	FOREIGN KEY (id_type_user) REFERENCES TYPE_USER(id_type_user)
);

CREATE TABLE REPORT (
    id_neighborhood_board INTEGER NOT NULL,
    id_report INTEGER GENERATED ALWAYS AS IDENTITY, -- Autoincrementable
    rut  VARCHAR(10),
	id_type_user INTEGER NOT NULL,
    title VARCHAR(50) NOT NULL, 
    description VARCHAR(1000) NOT NULL, 
    image_path VARCHAR(200),
    id_status INTEGER NOT NULL,
	date_report TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	date_approved TIMESTAMP,
    PRIMARY KEY (id_report, id_neighborhood_board),
    FOREIGN KEY (id_neighborhood_board, rut, id_type_user) REFERENCES USER_NEIGHBORHOOD_BOARD(id_neighborhood_board, rut, id_type_user),
    FOREIGN KEY (id_status) REFERENCES STATUS(id_status)
);

CREATE TABLE CERTIFICATE (
    id_neighborhood_board INTEGER NOT NULL,
	id_certificate INTEGER GENERATED ALWAYS AS IDENTITY,
    rut VARCHAR(10) NOT NULL, 
	id_type_user INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
	address VARCHAR(100) NULL, 
    evidence_image_path VARCHAR(200),
	evidence_pay_path VARCHAR(200),
	pdf_path VARCHAR(200),
	request_day TIMESTAMP NOT NULL, 
    approved_date TIMESTAMP,
    approved_by VARCHAR(100),
	cellphone varchar(15), 
    id_status INTEGER NOT NULL,
	PRIMARY KEY (id_certificate, id_neighborhood_board),
    FOREIGN KEY (rut, id_neighborhood_board, id_type_user) REFERENCES USER_NEIGHBORHOOD_BOARD(rut, id_neighborhood_board, id_type_user),
    FOREIGN KEY (id_status) REFERENCES STATUS(id_status)
);

CREATE TABLE EMERGENCY_CATEGORY (
    id_neighborhood_board INTEGER NOT NULL,
	id_category INTEGER GENERATED ALWAYS AS IDENTITY,
    category VARCHAR(100) NOT NULL,
	PRIMARY KEY (id_category, id_neighborhood_board),
    FOREIGN KEY (id_neighborhood_board) REFERENCES NEIGHBORHOOD_BOARD(id_neighborhood_board)
);

CREATE TABLE EMERGENCY (
	id_neighborhood_board_user INTEGER NOT NULL,
	id_neighborhood_board_category INTEGER NOT NULL,
	id_emergency INTEGER GENERATED ALWAYS AS IDENTITY, -- Autoincrementable 
	id_type_user INTEGER NOT NULL,
	id_category INTEGER NOT NULL,
    rut VARCHAR(10) NOT NULL,
    address VARCHAR(200),
    description VARCHAR(500),
	latitude VARCHAR(20), 
	longitude VARCHAR(20), 
	date_emergency TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id_emergency, id_neighborhood_board_user, id_neighborhood_board_category),
    FOREIGN KEY (id_neighborhood_board_user, rut, id_type_user) REFERENCES USER_NEIGHBORHOOD_BOARD(id_neighborhood_board, rut, id_type_user),
    FOREIGN KEY (id_category, id_neighborhood_board_category) REFERENCES EMERGENCY_CATEGORY(id_category, id_neighborhood_board)
);

CREATE TABLE COMMON_AREA (
    id_neighborhood_board INTEGER NOT NULL,
	id_common_area INTEGER GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
	address VARCHAR(50) NOT NULL, 
    start_time TIME NOT NULL,
    end_hours TIME NOT NULL,
	PRIMARY KEY (id_neighborhood_board, id_common_area),
    FOREIGN KEY (id_neighborhood_board) REFERENCES NEIGHBORHOOD_BOARD(id_neighborhood_board)
);

CREATE TABLE MAXIMUM_HOURS_COMMON_AREA (
    id_neighborhood_board INTEGER NOT NULL,
	id_common_area INTEGER NOT NULL,
    number_hours INTEGER NOT NULL,
    PRIMARY KEY (id_common_area, id_neighborhood_board),
    FOREIGN KEY (id_common_area, id_neighborhood_board) REFERENCES COMMON_AREA(id_common_area, id_neighborhood_board)
);

CREATE TABLE EXCEPTION_OF_DAYS (
    id_neighborhood_board INTEGER NOT NULL,
	id_common_area INTEGER NOT NULL,
    date_exception DATE NOT NULL,
    PRIMARY KEY (id_common_area, date_exception, id_neighborhood_board),
    FOREIGN KEY (id_common_area, id_neighborhood_board) REFERENCES COMMON_AREA(id_common_area, id_neighborhood_board)
);

CREATE TABLE RESERVATION (
	id_neighborhood_board_common_area INTEGER NOT NULL,
	id_neighborhood_board_user INTEGER NOT NULL,
	id_reservation INTEGER GENERATED ALWAYS AS IDENTITY, -- Autoincrementable 
	id_type_user INTEGER NOT NULL,
	id_common_area INTEGER NOT NULL,
    rut VARCHAR(10) NOT NULL,
	date_reservation DATE NOT NULL,
    start_hour TIME NOT NULL,
    end_hour TIME NOT NULL,
	number_hours INTEGER NOT NULL, 
	enabled BOOLEAN NOT NULL, 
    PRIMARY KEY (id_neighborhood_board_user, id_neighborhood_board_common_area, id_reservation),
    FOREIGN KEY (rut, id_neighborhood_board_user, id_type_user) REFERENCES USER_NEIGHBORHOOD_BOARD(rut, id_neighborhood_board, id_type_user),
    FOREIGN KEY (id_common_area, id_neighborhood_board_common_area) REFERENCES COMMON_AREA(id_common_area, id_neighborhood_board)
);

