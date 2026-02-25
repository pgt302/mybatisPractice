use boardProjectEx;

DROP TABLE IF EXISTS member;

CREATE TABLE member (
	memberId varchar(50) primary key,
    password varchar(50) not null,
    email varchar(50),
    phone varchar(17)
);

CREATE TABLE board (
	boardNum INT primary key,
    memberId varchar(50) references member(memberId),
    content varchar(3000),
    boardDate DATETIME DEFAULT now(),
    phone varchar(17)
    );

-- 시퀀스 구현을 위한 테이블
CREATE TABLE sequences(
	name varchar(32) primary key,
    currval BIGINT UNSIGNED NOT NULL DEFAULT 0
    )ENGINE=InnoDB;
  
-- 시퀀스 생성 프로시저
DELIMITER $$
CREATE PROCEDURE create_sequence(IN the_name varchar(32))
MODIFIES SQL DATA
DETERMINISTIC
BEGIN
	DELETE FROM sequences
    WHERE name = the_name;
    
    INSERT INTO sequences(name, currval)
    VALUES (the_name, 0);
END $$
DELIMITER ;

-- 시퀀스 nextval함수 구현
DELIMITER $$
CREATE FUNCTION nextval(the_name VARCHAR(32))
RETURNS BIGINT UNSIGNED
MODIFIES SQL DATA
DETERMINISTIC
BEGIN 
    DECLARE ret BIGINT UNSIGNED;
    UPDATE sequences SET currval = currval + 1 
    WHERE name = the_name;
    
    SELECT currval INTO ret FROM sequences
    WHERE name = the_name LIMIT 1;
    RETURN ret;
END $$
DELIMITER ;

-- 시퀀스