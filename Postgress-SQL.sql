CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role_id INT REFERENCES role(id),
    approved BOOLEAN DEFAULT FALSE
);

CREATE TABLE document (
    id SERIAL PRIMARY KEY,
    filename TEXT,
    filetype TEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE epqlist (
    id SERIAL PRIMARY KEY,
    name TEXT,
    code TEXT UNIQUE,
    quantity INT,
    status TEXT,
    note TEXT,
    image BYTEA
);

CREATE TABLE toollist (
    id SERIAL PRIMARY KEY,
    name TEXT,
    code TEXT UNIQUE,
    quantity INT,
    note TEXT
);

CREATE TABLE eqpchecksheet (
    id SERIAL PRIMARY KEY,
    eqp_id INT REFERENCES epqlist(id),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    values JSONB
);

CREATE TABLE eqpmaintenance (
    id SERIAL PRIMARY KEY,
    eqp_id INT REFERENCES epqlist(id),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);

CREATE TABLE troubleshooting (
    id SERIAL PRIMARY KEY,
    eqp_id INT REFERENCES epqlist(id),
    error TEXT,
    status TEXT DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO "user" (username, password_hash, created_at, role_id, approved)
VALUES ('admin', '$2a$12$3mz3ylxxQroEZMzH8OsLGuTnDytY5c7fCPkPERWUN1KHhCVsfXEdq', NOW(), 0, TRUE);

ALTER TABLE "user" ADD COLUMN reset_requested BOOLEAN DEFAULT FALSE;


CREATE OR REPLACE FUNCTION sp_login(_username TEXT, _password TEXT)
RETURNS TABLE(user_id INT, role_id INT, password_hash TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT id, role_id, password_hash
    FROM "user"
    WHERE username = _username AND approved = TRUE;
END;
$$ LANGUAGE plpgsql;
