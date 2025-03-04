USE bd_ecoguia;

-- TRIGGERS para backlog do banco de dados dos últimos 15 dias abaixo:
-- ¨¨log de criação, edição e exclusão de artigos;
-- ¨¨log de criação, edição e exclusão de dicas;
-- Criação de tabelas triggers abaixo:

CREATE TABLE backlog_article_CUD(
	pk_IDbacklog_article   INT PRIMARY KEY AUTO_INCREMENT,
	type_action			   VARCHAR(120) NOT NULL,
    date_action		       DATE DEFAULT(CURRENT_DATE),
    fk_IDarticle		   INT,
    title_article	 	   VARCHAR(120)  NOT NULL,
	category_article       VARCHAR(40)   NOT NULL,
    date_article	       DATE 		 NOT NULL,
    reference_article	   VARCHAR(2048) NOT NULL
    
);

CREATE TABLE backlog_material_U(
    pk_IDbacklog_material  INT PRIMARY KEY AUTO_INCREMENT,
	type_action			   VARCHAR(120) NOT NULL,
    date_action		       DATE DEFAULT(CURRENT_DATE),
    fk_IDmaterial		   INT,
    title_material  	   VARCHAR(120),
    XP_material            INT

);

CREATE TABLE backlog_level_CD(
    pk_IDbacklog_level     INT PRIMARY KEY AUTO_INCREMENT,
	type_action			   VARCHAR(120) NOT NULL,
    date_action		       DATE DEFAULT(CURRENT_DATE),
    fk_IDlevel  		   INT,
    XP_level               INT
    
);

CREATE TABLE backlog_quest_CUD(
	pk_IDbacklog_quest	   INT PRIMARY KEY AUTO_INCREMENT,
	type_action			   VARCHAR(120) NOT NULL,
    date_action		       DATE DEFAULT(CURRENT_DATE),
    fk_IDquest			   INT,
    description_quest	   VARCHAR(120),
    fk_badge_quest         INT
    
);

CREATE TABLE backlog_tip_CUD(
	pk_IDbacklog_tip	   INT PRIMARY KEY AUTO_INCREMENT,
	type_action			   VARCHAR(120) NOT NULL,
    date_action		       DATE DEFAULT(CURRENT_DATE),
    fk_IDtip			   INT,
    description_tip		   VARCHAR(280),
    date_tip	       	   DATE 		NOT NULL
    
);

CREATE TABLE backlog_user_CD(
    pk_IDbacklog_user	   INT PRIMARY KEY AUTO_INCREMENT,
	type_action			   VARCHAR(120) NOT NULL,
    date_action		       DATE DEFAULT(CURRENT_DATE),
    fk_IDuser              INT,
    nickname_user          VARCHAR(120)
    
);
DELIMITER //

-- article
CREATE TRIGGER trg_article_insert AFTER INSERT
ON tbl_article 
FOR EACH ROW 
BEGIN
	INSERT INTO backlog_article_CUD(
		fk_IDarticle,
		title_article,
		category_article,
		date_article,
        reference_article,
		type_action,
		date_action
	)
    VALUES(
		NEW.pk_IDarticle,
		NEW.title_article,
        NEW.category_article,
        NEW.date_article,
        NEW.reference_article,
        'INSERT',
        CURRENT_DATE()
    );
END //

CREATE TRIGGER trg_article_update AFTER UPDATE
ON tbl_article
FOR EACH ROW
BEGIN
	INSERT INTO backlog_article_CUD(
		fk_IDarticle,
        title_article,
		category_article,
        date_article,
        reference_article,
		type_action,
		date_action
	)
    VALUES(
		OLD.pk_IDarticle,
        IFNULL(NEW.description_article, OLD.description_article),
        IFNULL(NEW.category_article,    OLD.category_article),
		NEW.date_article,
        IFNULL(NEW.reference_article,   OLD.reference_article),
        'UPDATE',
        CURRENT_DATE()
    );
END //

CREATE TRIGGER trg_article_delete AFTER DELETE
ON tbl_article 
FOR EACH ROW 
BEGIN
	INSERT INTO backlog_article_CUD(
		fk_IDarticle,
		title_article,
		category_article,
		date_article,
        reference_article,
		type_action,
		date_action
	)
    VALUES(
		OLD.pk_IDarticle,
		OLD.title_article,
        OLD.category_article,
        OLD.date_article,
        OLD.reference_article,
        'DELETE',
        CURRENT_DATE()
    );
END //

-- material
CREATE TRIGGER trg_material_update AFTER UPDATE
ON tbl_material
FOR EACH ROW
BEGIN
	INSERT INTO backlog_material_U(
		fk_IDmaterial,
        title_material,
		XP_material,
		type_action,
		date_action
	)
    VALUES(
		OLD.pk_IDmaterial,
        IFNULL(NEW.title_material, OLD.title_material),
        IFNULL(NEW.XP_material,    OLD.XP_material),
        'UPDATE',
        CURRENT_DATE()
    );
END //

-- level
CREATE TRIGGER trg_level_insert AFTER INSERT
ON tbl_level
FOR EACH ROW 
BEGIN
	INSERT INTO backlog_level_CD(
		fk_IDlevel,
		XP_level,
        type_action,
		date_action
	)
    VALUES(
		NEW.pk_IDlevel,
		NEW.XP_level,
        'INSERT',
        CURRENT_DATE()
    );
END //

CREATE TRIGGER trg_level_delete AFTER DELETE
ON tbl_level
FOR EACH ROW 
BEGIN
	INSERT INTO backlog_level_CD(
		fk_IDlevel,
		XP_level,
		type_action,
		date_action
	)
    VALUES(
		OLD.pk_IDlevel,
		OLD.XP_level,
        'DELETE',
        CURRENT_DATE()
    );
END //

-- quest
CREATE TRIGGER trg_quest_insert AFTER INSERT
ON tbl_quest
FOR EACH ROW 
BEGIN
	INSERT INTO backlog_quest_CUD(
		fk_IDquest,
		description_quest,
        fk_badge_quest,
		type_action,
		date_action
	)
    VALUES(
		NEW.pk_IDquest,
		NEW.description_quest,
        NEW.fk_badge_quest,
        'INSERT',
        CURRENT_DATE()
    );
END //

CREATE TRIGGER trg_quest_update AFTER UPDATE
ON tbl_quest
FOR EACH ROW
BEGIN
	INSERT INTO backlog_quest_CUD(
		fk_IDquest,
		description_quest,
        fk_badge_quest,
		type_action,
		date_action
	)
    VALUES(
		OLD.pk_IDquest,
		IFNULL(NEW.description_quest, OLD.description_quest),
        IFNULL(NEW.fk_badge_quest, OLD.fk_badge_quest),
        'UPDATE',
        CURRENT_DATE()
    );
END //

CREATE TRIGGER trg_quest_delete AFTER DELETE
ON tbl_quest
FOR EACH ROW 
BEGIN
	INSERT INTO backlog_quest_CUD(
		fk_IDquest,
		description_quest,
        fk_badge_quest,
		type_action,
		date_action
	)
    VALUES(
		OLD.pk_IDquest,
		OLD.description_quest,
        OLD.fk_badge_quest,
        'DELETE',
        CURRENT_DATE()
    );
END //

-- tip
CREATE TRIGGER trg_tip_insert AFTER INSERT
ON tbl_tip
FOR EACH ROW
BEGIN
	INSERT INTO backlog_tip_CUD(
		fk_IDtip,
		date_tip,
		type_action,
		date_action
	)
    VALUES(
		NEW.pk_IDtip,
		NEW.date_tip,
        'INSERT',
        CURRENT_DATE()
    );
END //

CREATE TRIGGER trg_tip_update AFTER UPDATE
ON tbl_tip
FOR EACH ROW
BEGIN
	INSERT INTO backlog_tip_CUD(
		fk_IDtip,
        description_tip,
		date_tip,
		type_action,
		date_action
	)
    VALUES(
		OLD.pk_IDtip,
        IFNULL(NEW.description_tip, OLD.description_tip),
		NEW.date_tip,
        'UPDATE',
        CURRENT_DATE()
    );
END //

CREATE TRIGGER trg_tip_delete AFTER DELETE
ON tbl_tip
FOR EACH ROW
BEGIN
	INSERT INTO backlog_tip_CUD(
		fk_IDtip,
        description_tip,
		date_tip,
		type_action,
		date_action
	)
    VALUES(
		OLD.pk_IDtip,
        OLD.description_tip,
        OLD.date_tip,
        'DELETE',
        CURRENT_DATE()
    );
END //

-- user
CREATE TRIGGER trg_user_insert AFTER INSERT
ON tbl_user
FOR EACH ROW
BEGIN
    INSERT INTO backlog_user_CD(
        fk_IDuser,
        nickname_user,
        type_action,
        date_action
    )
    VALUES(
		NEW.pk_IDuser,
        NEW.nickname_user,
        'INSERT',
        CURRENT_DATE()
    );
END //

CREATE TRIGGER trg_user_delete AFTER DELETE
ON tbl_user
FOR EACH ROW
BEGIN
	INSERT INTO backlog_user_CD(
        fk_IDuser,
        nickname_user,
        type_action,
        date_action
    )
    VALUES(
		OLD.pk_IDuser,
        OLD.nickname_user,
        'DELETE',
        CURRENT_DATE()
    );
END //

SET SQL_SAFE_UPDATES = 0//

CREATE EVENT cleanup_backlog
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 DAY
ON COMPLETION PRESERVE
DO BEGIN 
	DELETE FROM backlog_quest_CUD   WHERE date_action < DATE_SUB(NOW(), INTERVAL 7 DAY);
	DELETE FROM backlog_article_CUD WHERE date_action < DATE_SUB(NOW(), INTERVAL 7 DAY);
	DELETE FROM backlog_level_CD    WHERE date_action < DATE_SUB(NOW(), INTERVAL 7 DAY);
	DELETE FROM backlog_material_U  WHERE date_action < DATE_SUB(NOW(), INTERVAL 7 DAY);
    DELETE FROM backlog_tip_CUD     WHERE date_action < DATE_SUB(NOW(), INTERVAL 7 DAY);
END//

DELIMITER ;

USE bd_ecoguia;
SELECT * FROM backlog_quest_CUD;