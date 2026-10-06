CREATE DATABASE IF NOT EXISTS coding_platform;
USE coding_platform;

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'USER') DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS contests (
    contest_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    contest_code VARCHAR(20) NOT NULL UNIQUE,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    duration_minutes INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS problems (
    problem_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    input_format TEXT,
    output_format TEXT,
    constraints TEXT,
    difficulty ENUM('Easy', 'Medium', 'Hard') NOT NULL,
    category VARCHAR(100),
    points INT DEFAULT 10,
    time_complexity VARCHAR(100),
    space_complexity VARCHAR(100),
    complexity_explanation TEXT,
    source VARCHAR(100),
    source_url VARCHAR(255),
    external_problem_id VARCHAR(100),
    imported_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS contest_problems (
    contest_id INT,
    problem_id INT,
    order_index INT DEFAULT 0,
    PRIMARY KEY (contest_id, problem_id),
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id) ON DELETE CASCADE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS test_cases (
    test_case_id INT AUTO_INCREMENT PRIMARY KEY,
    problem_id INT,
    input_data TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    is_hidden BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS allowed_languages (
    contest_id INT,
    language VARCHAR(20),
    PRIMARY KEY (contest_id, language),
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    contest_id INT,
    user_id INT,
    problem_id INT,
    language VARCHAR(20) NOT NULL,
    source_code TEXT NOT NULL,
    status VARCHAR(50) NOT NULL, -- ACCEPTED, WRONG ANSWER, etc.
    execution_time INT, -- in milliseconds
    memory_used INT, -- in MB or KB
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS leaderboard (
    contest_id INT,
    user_id INT,
    total_score INT DEFAULT 0,
    last_accepted_time TIMESTAMP,
    PRIMARY KEY (contest_id, user_id),
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
