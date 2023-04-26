-- Create tables for First Normal Form
CREATE TABLE pokemon (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    type1_id INTEGER,
    type2_id INTEGER,
    FOREIGN KEY (type1_id) REFERENCES pokemon_type(id),
    FOREIGN KEY (type2_id) REFERENCES pokemon_type(id)
);

CREATE TABLE pokemon_type (
    id INTEGER PRIMARY KEY,
    type_name TEXT NOT NULL UNIQUE
);

CREATE TABLE pokemon_stats (
    id INTEGER PRIMARY KEY,
    pokemon_id INTEGER,
    hp INTEGER,
    attack INTEGER,
    defense INTEGER,
    sp_attack INTEGER,
    sp_defense INTEGER,
    speed INTEGER,
    FOREIGN KEY (pokemon_id) REFERENCES pokemon(id)
);

CREATE TABLE pokemon_ability (
    id INTEGER PRIMARY KEY,
    ability_name TEXT NOT NULL UNIQUE
);

CREATE TABLE pokemon_ability_relation (
    id INTEGER PRIMARY KEY,
    pokemon_id INTEGER,
    ability_id INTEGER,
    FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
    FOREIGN KEY (ability_id) REFERENCES pokemon_ability(id)
);

-- Insert data into tables
INSERT INTO pokemon_type (type_name)
SELECT DISTINCT Type1
FROM imported_pokemon_data
UNION
SELECT DISTINCT Type2
FROM imported_pokemon_data
WHERE Type2 IS NOT NULL;

INSERT INTO pokemon_ability (ability_name)
SELECT DISTINCT Ability1
FROM imported_pokemon_data
UNION
SELECT DISTINCT Ability2
FROM imported_pokemon_data
WHERE Ability2 IS NOT NULL
UNION
SELECT DISTINCT Ability3
FROM imported_pokemon_data
WHERE Ability3 IS NOT NULL;

INSERT INTO pokemon (id, name, type1_id, type2_id)
SELECT
    ID,
    Name,
    (SELECT id FROM pokemon_type WHERE type_name = Type1),
    (SELECT id FROM pokemon_type WHERE type_name = Type2)
FROM imported_pokemon_data;

INSERT INTO pokemon_stats (pokemon_id, hp, attack, defense, sp_attack, sp_defense, speed)
SELECT
    ID,
    HP,
    Attack,
    Defense,
    Sp_Atk,
    Sp_Def,
    Speed
FROM imported_pokemon_data;

INSERT INTO pokemon_ability_relation (pokemon_id, ability_id)
SELECT
    ID,
    (SELECT id FROM pokemon_ability WHERE ability_name = Ability1)
FROM imported_pokemon_data
UNION
SELECT
    ID,
    (SELECT id FROM pokemon_ability WHERE ability_name = Ability2)
FROM imported_pokemon_data
WHERE Ability2 IS NOT NULL
UNION
SELECT
    ID,
    (SELECT id FROM pokemon_ability WHERE ability_name = Ability3)
FROM imported_pokemon_data
WHERE Ability3 IS NOT NULL;


-- ec Add the new Pokemon "Huskichu" and "Cougarite":
INSERT INTO pokemon_type (type_name) VALUES ('Mascot');
INSERT INTO pokemon_ability (ability_name) VALUES ('Slow Attack');

INSERT INTO pokemon (name, type1_id)
VALUES ('Huskichu', (SELECT id FROM pokemon_type WHERE type_name = 'Mascot'));

INSERT INTO pokemon (name, type1_id)
VALUES ('Cougarite', (SELECT id FROM pokemon_type WHERE type_name = 'Mascot'));

INSERT INTO pokemon_ability_relation (pokemon_id, ability_id)
VALUES ((SELECT id FROM pokemon WHERE name = 'Cougarite'), (SELECT id FROM pokemon_ability WHERE ability_name = 'Slow Attack'));

-- Create the trainer table and add several trainers to the database:
CREATE TABLE trainer (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

INSERT INTO trainer (first_name, last_name)
VALUES ('Gloria', 'Hu'),
       ('Kaarina ', 'Tulleau'),
       ('Professor', 'Oak'),
       ('Jeff', 'Tu');

-- Create a table to store the trainers' favorite Pokemon types and Pokemon teams:
      CREATE TABLE trainer_favorite_type (
    id INTEGER PRIMARY KEY,
    trainer_id INTEGER,
    type_id INTEGER,
    FOREIGN KEY (trainer_id) REFERENCES trainer(id),
    FOREIGN KEY (type_id) REFERENCES pokemon_type(id)
);
