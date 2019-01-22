PRAGMA foreign_keys = ON;
DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE question_follows;
DROP TABLE questions;
DROP TABLE users;


CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    reply_body TEXT,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('Mason','Chinkin'),
    ('Tamir','Karssli');


-- Questions -------
INSERT INTO
    questions (title, body, author_id)
VALUES
    ("where's my car?", 'dude...', (SELECT id FROM users WHERE fname = 'Mason'));
INSERT INTO
    questions (title, body, author_id)
VALUES
    ("Is this my dog?", 'mmmmmmmm', (SELECT id FROM users WHERE fname = 'Mason'));
INSERT INTO
    questions (title, body, author_id)
VALUES
    ("What is the meaning of life?", 'asdadasdasdasd', (SELECT id FROM users WHERE fname = 'Tamir'));


-- Question Follows -------
INSERT INTO
    question_follows (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = "where's my car?"),
    (SELECT id FROM users WHERE fname = "Tamir"));

INSERT INTO
    question_follows (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = "where's my car?"),
    (SELECT id FROM users WHERE fname = "Mason"));

INSERT INTO
    question_follows (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = "Is this my dog?"),
    (SELECT id FROM users WHERE fname = "Mason"));

-- Replies ----------
INSERT INTO
    replies (question_id, user_id, parent_reply_id, reply_body)
VALUES
    ((SELECT id FROM questions WHERE title = "where's my car?"),
    (SELECT id FROM users WHERE fname = "Tamir"),
    (SELECT MAX(id) FROM replies WHERE question_id = (SELECT id FROM questions WHERE title = "where's my car?")), 
    "I have no idea");

INSERT INTO
    replies (question_id, user_id, parent_reply_id, reply_body)
VALUES
    ((SELECT id FROM questions WHERE title = "where's my car?"),
    (SELECT id FROM users WHERE fname = "Mason"),
    (SELECT MAX(id) FROM replies WHERE question_id = (SELECT id FROM questions WHERE title = "where's my car?")), 
    "I do have an idea");

INSERT INTO
    replies (question_id, user_id, parent_reply_id, reply_body)
VALUES
    ((SELECT id FROM questions WHERE title = "where's my car?"),
    (SELECT id FROM users WHERE fname = "Tamir"),
    (SELECT MAX(id) FROM replies WHERE question_id = (SELECT id FROM questions WHERE title = "where's my car?")), 
    "I forgot your idea");

-- Question Likes -------
INSERT INTO
    question_likes (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = "where's my car?"),
    (SELECT id FROM users WHERE fname = "Tamir"));

INSERT INTO
    question_likes (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = "Is this my dog?"),
    (SELECT id FROM users WHERE fname = "Mason"));

INSERT INTO
    question_likes (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = "where's my car?"),
    (SELECT id FROM users WHERE fname = "Mason"));
    