DROP DATABASE IF EXISTS bd_ecoguia;
CREATE DATABASE IF NOT EXISTS bd_ecoguia;
USE bd_ecoguia;
-- WARNING ERROR: possível erro com CURRENT_DATA devido a falha de conexão com o servidor
-- WARNING ERROR: possível erro com EVENT_SCHEDULER devido a nível de autorização com o servidor

-- Criação de tabelas padrões abaixo:
CREATE TABLE tbl_article(
	pk_IDarticle	 	INT PRIMARY KEY AUTO_INCREMENT,
    image_article		VARCHAR(2048) NOT NULL,
    title_article	 	VARCHAR(280)  NOT NULL,
	category_article 	ENUM('noticia', 'artigo', 'faca voce mesmo') NOT NULL,
    description_article TEXT NOT NULL,
    date_article		DATE DEFAULT(CURRENT_DATE),
    reference_article	VARCHAR(2048) NOT NULL
);

CREATE TABLE tbl_avatar(
	pk_IDavatar		INT PRIMARY KEY AUTO_INCREMENT,
    blob_avatar		VARCHAR(2048) NOT NULL
	-- Em lançamento, serão feitos registros fixos
    -- sem possibilidade de alteração! TOTAL: 9
);

CREATE TABLE tbl_badge(
	pk_IDbadge			INT PRIMARY KEY AUTO_INCREMENT,
    title_badge			VARCHAR(40)	  NOT NULL,
    description_badge	VARCHAR(280)  NOT NULL,
    blob_badge			VARCHAR(2048) NOT NULL
	-- Em lançamento, serão feitos registros fixos
    -- sem possibilidade de alteração! TOTAL: 10
);

CREATE TABLE tbl_level(
	pk_IDlevel		INT PRIMARY KEY AUTO_INCREMENT,
    XP_level		INT NOT NULL
	-- Em lançamento, serão feitos registros fixos
    -- sem possibilidade de alteração! TOTAL: 60
);

CREATE TABLE tbl_material( 
	pk_IDmaterial	INT PRIMARY KEY AUTO_INCREMENT,
    title_material	VARCHAR(40) NOT NULL,
    XP_material		INT			NOT NULL
	-- Em lançamento, serão feitos registros fixos
    -- sem possibilidade de alteração! TOTAL: 5
);

-- WARNING: tbl_quest não necessita de um badge para existir!
-- tbl_quest deve ser associada a uma badge a cada 2 missões
CREATE TABLE tbl_quest(
	pk_IDquest			INT PRIMARY KEY AUTO_INCREMENT,
    description_quest	VARCHAR(280) NOT NULL,
    XP_quest			INT NOT NULL,
    fk_badge_quest		INT,
    
    FOREIGN KEY(fk_badge_quest) REFERENCES tbl_badge(pk_IDbadge)
	-- Em lançamento, serão feitos registros fixos
    -- sem possibilidade de alteração! TOTAL: 30
);

CREATE TABLE tbl_tip(
	pk_IDtip			INT PRIMARY KEY AUTO_INCREMENT,
    description_tip		VARCHAR(280) NOT NULL,
    date_tip			DATE DEFAULT(CURRENT_DATE)
);

-- WARNING: popular tbl_level, tbl_avatar com, ao menos, UM registro!
-- tbl_admin necessita desta tabela e o 1º registro dela por padrão.
CREATE TABLE tbl_admin(
	pk_IDadmin			INT PRIMARY KEY AUTO_INCREMENT,
    name_admin			VARCHAR(60)  NOT NULL,
    lastname_admin		VARCHAR(60)  NOT NULL,
    email_admin			VARCHAR(120) NOT NULL,
    password_admin		VARCHAR(74)	 NOT NULL,
    fk_avatar_admin		INT DEFAULT 1,
    
    FOREIGN KEY(fk_avatar_admin) REFERENCES tbl_avatar(pk_IDavatar)
);

-- WARNING: popular tbl_level, tbl_avatar e tbl_quest com, ao menos, UM registro!
-- tbl_user necessita destas tabelas e o 1º registro delas por padrão.
CREATE TABLE tbl_user(
	pk_IDuser		INT PRIMARY KEY AUTO_INCREMENT,
    name_user		VARCHAR(60)  NOT NULL,
    lastname_user	VARCHAR(60)  NOT NULL,
    email_user		VARCHAR(120) NOT NULL,
    password_user	VARCHAR(120) NOT NULL,
    fk_level_user	INT	DEFAULT 1,
    fk_avatar_user	INT DEFAULT 1,
    XP_user			INT DEFAULT 0,
    nickname_user 	VARCHAR(120) NOT NULL,
    fk_quest_user	INT DEFAULT 1,
    
	FOREIGN KEY(fk_level_user)    REFERENCES tbl_level 	  (pk_IDlevel),
    FOREIGN KEY(fk_avatar_user)   REFERENCES tbl_avatar	  (pk_IDavatar),
    FOREIGN KEY(fk_quest_user)    REFERENCES tbl_quest    (pk_IDquest)
);