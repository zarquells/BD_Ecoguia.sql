USE bd_ecoguia;

-- Stored Procedures abaixo para comandos padrões de acordo com a função:
-- ¨¨Criar registros globais;
-- ¨¨Modificar registros;
-- ¨¨Visualizar registros;
-- ¨¨Excluir registros.

DELIMITER //
-- PADRÃO USUÁRIO
-- criação de usuário, acesso padrão
CREATE PROCEDURE CreateUser(
	IN proc_name 		VARCHAR(60),
	IN proc_lastname	VARCHAR(60),
    IN proc_email		VARCHAR(120),
    IN proc_password	VARCHAR(120),
    IN proc_nickname 	VARCHAR(120),
    IN proc_fk_avatar	INT
)
BEGIN
    INSERT INTO tbl_user(
		name_user, 
        lastname_user, 
        email_user, 
        password_user,
        nickname_user,
        fk_avatar_user

    )
    VALUES(
		proc_name, 
        proc_lastname, 
        proc_email, 
        proc_password,
        proc_nickname,
        proc_fk_avatar
        
    );
END //

-- visualização de usuário, acesso padrão
CREATE PROCEDURE SelectProfile(
    IN proc_IDuser INT
)
BEGIN 
    DECLARE proc_lastbadge INT;

    SELECT q.fk_badge_quest INTO proc_lastbadge FROM tbl_quest q
    JOIN   tbl_user u  ON q.pk_IDquest <=  u.fk_quest_user
    WHERE  u.pk_IDuser = proc_IDuser AND q.fk_badge_quest IS NOT NULL
    ORDER BY q.pk_IDquest DESC
    LIMIT 1;

    -- Seleciona as informações do perfil e o último badge conquistado
    SELECT 
        u.nickname_user, 
        a.blob_avatar, 
        u.name_user, 
        u.lastname_user, 
		u.XP_user,
        l.XP_level,
        u.fk_level_user,
        b.*
    FROM 
        tbl_user u
    JOIN 
        tbl_avatar a ON u.fk_avatar_user = a.pk_IDavatar
    JOIN 
        tbl_level l ON u.fk_level_user = l.pk_IDlevel
    JOIN 
        tbl_quest q ON u.fk_quest_user = q.pk_IDquest
    LEFT JOIN 
        tbl_badge b ON b.pk_IDbadge    = proc_lastbadge
    WHERE 
        u.pk_IDuser = proc_IDuser;
END //

-- visualização de XP, quest e level de usuário, acesso padrão
CREATE PROCEDURE SelectXPUser(
	IN proc_IDuser	INT
)
BEGIN
    DECLARE proc_nextlevel	 INT;
	DECLARE proc_nextlevelXP INT;
	DECLARE proc_nextquest   INT;
	DECLARE proc_nextquestXP INT;

	SELECT pk_IDlevel, XP_level INTO proc_nextlevel, proc_nextlevelXP
    FROM tbl_level
    WHERE pk_IDlevel = (
		SELECT fk_level_user FROM tbl_user
        WHERE pk_IDuser = proc_IDuser
    ) + 1;

    SELECT pk_IDquest, XP_quest INTO proc_nextquest, proc_nextquestXP
    FROM tbl_quest
    WHERE pk_IDquest = (
		SELECT fk_quest_user FROM tbl_user
        WHERE pk_IDuser = proc_IDuser
    ) + 1;
    
	SELECT 
		u.nickname_user,
		u.XP_user,
        
		l.pk_IDlevel     AS ID_nowlevel,
        l.XP_level		 AS XP_nowlevel,
        proc_nextlevel   AS ID_nextlevel,
        proc_nextlevelXP AS XP_nextlevel,
        
		q.pk_IDquest     AS ID_nowquest,
        q.XP_quest		 AS XP_nowquest,
        proc_nextquest 	 AS ID_nextquest,
        proc_nextquestXP AS XP_nextquest
        
	FROM tbl_user u
    JOIN tbl_level l ON u.fk_level_user = l.pk_IDlevel
    JOIN tbl_quest q ON u.fk_quest_user = q.pk_IDquest
    WHERE u.pk_IDuser = proc_IDuser;
        
END //

-- Pegar o rank do Usuário
CREATE PROCEDURE SelectRanking(
    IN IdUser INT
)
BEGIN
	WITH RankUsers AS (
		SELECT u.pk_IDuser, u.nickname_user, u.XP_user, u.fk_avatar_user, a.blob_avatar, 
		ROW_NUMBER() OVER (ORDER BY u.XP_user ASC) AS position
		FROM viewallnicknames u
		INNER JOIN tbl_avatar a ON a.pk_IDavatar = u.fk_avatar_user
	)
        
	SELECT 
        present_user.pk_IDuser AS current_user_id,
        present_user.nickname_user AS current_nickname,
        present_user.XP_user AS current_xp,
        previous_user.pk_IDuser AS previous_user_id,
        previous_user.nickname_user AS previous_nickname,
        previous_user.XP_user AS previous_xp,
        next_user.pk_IDuser AS next_user_id,
        next_user.nickname_user AS next_nickname,
        next_user.XP_user AS next_xp,
        present_user.position AS current_position
	FROM RankUsers present_user
	LEFT JOIN RankUsers previous_user ON previous_user.position = present_user.position - 1
	LEFT JOIN RankUsers next_user ON next_user.position = present_user.position + 1
    WHERE present_user.pk_IDuser = idUser;
END //

-- modificação de XP, level por quest ou reciclagem de material de usuário, acesso padrão
CREATE PROCEDURE ModifyLevelUser(
	IN proc_IDuser	INT,
    IN proc_XPuser  INT,
    IN proc_leveluser INT,
    IN proc_questuser INT
    
)
BEGIN
	UPDATE tbl_user u
    SET
		XP_user 	  = IFNULL( proc_XPuser, XP_user),
		fk_level_user = IFNULL( proc_leveluser, fk_level_user),
        fk_quest_user = IFNULL( proc_questuser, fk_quest_user)
        
    WHERE 
		u.pk_IDuser = proc_IDuser;
        
END //

-- modificação de registro de usuário, acesso padrão
CREATE PROCEDURE ModifyProfile(
    IN proc_IDuser       INT,
    IN proc_name         VARCHAR(60),
    IN proc_lastname     VARCHAR(60),
    IN proc_avatar       INT
)
BEGIN 
    UPDATE tbl_user
    SET  
        name_user      = IFNULL(proc_name, name_user),
        lastname_user  = IFNULL(proc_lastname, lastname_user),
        fk_avatar_user = IFNULL(proc_avatar, fk_avatar_user)
        
    WHERE 
		pk_IDuser = proc_IDuser;
        
END //

-- modificação de email e senha de usuário, acesso padrão
CREATE PROCEDURE ModifyUser(
    IN proc_IDuser       INT,
    IN proc_email        VARCHAR(120),
    IN proc_pwd			 VARCHAR(120)
)
BEGIN 
    UPDATE tbl_user
    SET  
        email_user     = IFNULL(proc_email, email_user),
        password_user  = IFNULL(proc_pwd, password_user)
        
    WHERE 
		pk_IDuser      = proc_IDuser;
        
END //

-- exclusão de registro de usuário, acesso padrão
CREATE PROCEDURE DeleteUser(
    IN proc_IDuser       INT,
    IN proc_pwd     VARCHAR(74)
)
BEGIN 
    DECLARE itsExist   INT;

    SELECT COUNT(*) INTO itsExist
    FROM ViewAllEmails WHERE pk_IDuser = proc_IDuser;

    IF itsExist <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não foi encontrada conta de usuário.';
    END IF;

    DELETE FROM tbl_user
    WHERE pk_IDuser = proc_IDuser AND password_user = proc_pwd;
END //

-- ADMINISTRADOR
-- WARNING: Não é possível o administrador criar usuários ou modificá-los por este acesso por questões de segurança.
-- para criar usuários, faça através do nosso cadastro padrão

-- modificação de email e senha de admin, acesso administrador
CREATE PROCEDURE ModifyAdmin(
    IN proc_IDadmin      INT,
    IN proc_email        VARCHAR(120),
    IN proc_pwd			 VARCHAR(120)
)
BEGIN 
    UPDATE tbl_admin
    SET  
        email_admin     = IFNULL(proc_email, email_admin),
        password_admin  = IFNULL(proc_pwd, password_admin)
        
    WHERE 
		pk_IDadmin      = proc_IDadmin;
        
END //

-- criação de artigo, acesso administrador
CREATE PROCEDURE CreateArticle(
	IN proc_image		   VARCHAR(2048),
	IN proc_title          VARCHAR(280),
	IN proc_category       ENUM('noticia', 'artigo', 'faca voce mesmo'),
    IN proc_description    TEXT,
    IN proc_reference      VARCHAR(2048)
)
BEGIN
    INSERT INTO tbl_article(
		image_article,
		title_article, 
        category_article, 
        description_article,
        reference_article
    )
    VALUES(
		proc_image,
		proc_title, 
        proc_category, 
        proc_description,
        proc_reference
    );
END //

-- criação de level, acesso administrador
-- WARNING: Admin deve adicionar sempre um level maior do que o anterior
CREATE PROCEDURE CreateLevel(
    IN proc_XP	  INT
)
BEGIN
    DECLARE max_XP INT;

    SELECT MAX(XP_level) INTO max_XP 
    FROM tbl_level;
    
    IF proc_XP > max_XP THEN
        INSERT INTO tbl_level(XP_level)
        VALUES(proc_XP);
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'O novo level deve ser maior do que o anterior registrado';
    END IF;
END //
DROP PROCEDURE CreateQuestAndBadge//
-- criação de 3 quests e 1 badge, acesso administrador
-- WARNING: Admin deve adicionar 3 missões e 1 badge por vez
CREATE PROCEDURE CreateQuestAndBadge(
    IN proc_description  VARCHAR(280),
    IN proc_XP			 INT,
    
	IN proc_description1 VARCHAR(280),
    IN proc_XP1			 INT,
    
	IN proc_description2 VARCHAR(280),
    IN proc_XP2		     INT,
    
	IN proc_blob 		 	VARCHAR(2048),
	IN proc_blobtitle		VARCHAR(40),
    IN proc_blobdescription	VARCHAR(280)
)
BEGIN
	DECLARE proc_badge 	INT;
    
	INSERT INTO tbl_badge(blob_badge, title_badge, description_badge)
    VALUES(proc_blob, proc_blobtitle, proc_blobdescription);
	
    SET proc_badge  = LAST_INSERT_ID();

    INSERT INTO tbl_quest (description_quest, XP_quest, fk_badge_quest)
    VALUES (proc_description, proc_XP, null);

    INSERT INTO tbl_quest (description_quest, XP_quest, fk_badge_quest)
    VALUES (proc_description1, proc_XP1, null);

    INSERT INTO tbl_quest (description_quest, XP_quest, fk_badge_quest)
    VALUES (proc_description2, proc_XP2, proc_badge);
END //

-- criação de dica, acesso administrador
CREATE PROCEDURE CreateTip(
    IN proc_description VARCHAR(280)
)
BEGIN
    DECLARE isCreated INT;

    SELECT COUNT(*) INTO isCreated
    FROM tbl_tip
    WHERE description_tip = proc_description;
    
	IF isCreated > 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Já existe esta dica no banco de dados.';
    END IF;

    INSERT INTO tbl_tip(
		description_tip
    )
    VALUES(
		proc_description
        
    );
END //

-- modificação de registro de artigo, acesso administrador
CREATE PROCEDURE ModifyArticle(
    IN proc_IDarticle 	 INT,
    IN proc_image		 VARCHAR(2048),
    IN proc_title        VARCHAR(280),
    IN proc_category   	 ENUM('noticia', 'artigo', 'faca voce mesmo'),
    IN proc_description  TEXT,
    IN proc_reference 	 VARCHAR(2048)
    
)
BEGIN
	UPDATE tbl_article
	SET
		image_article   	= IFNULL(proc_image,		image_article),
		title_article		= IFNULL(proc_title, 		title_article),
		category_article	= IFNULL(proc_category,		category_article),
		description_article = IFNULL(proc_description,	description_article),
		reference_article 	= IFNULL(proc_reference,	reference_article),
		date_article		= CURRENT_DATE()
		
	WHERE
		pk_IDarticle = proc_IDarticle;
END //

-- modificação de registro de avatar, acesso administrador
CREATE PROCEDURE ModifyAvatar(
    IN proc_IDavatar  INT,
    IN proc_blob	  VARCHAR(2048)
    
)
BEGIN
	UPDATE tbl_avatar
	SET
		blob_avatar = IFNULL(proc_blob, blob_avatar)
	WHERE
		pk_IDavatar = proc_IDavatar;
END //

-- modifcação de registro de material, acesso administrador
CREATE PROCEDURE ModifyMaterial(
    IN proc_IDmaterial 	 INT,
    IN proc_title        VARCHAR(40),
    IN proc_XP			 INT	
    
)
BEGIN

    UPDATE tbl_material
    SET
		title_material		= IFNULL(proc_title, title_material),
        XP_material			= IFNULL(proc_XP, XP_material)
        
	WHERE
		pk_IDmaterial = proc_IDmaterial;
        
END //

-- modifcação de registro de missões, acesso administrador
CREATE PROCEDURE ModifyQuestAndBadge(
	IN proc_IDquest 	 	INT,            
    IN proc_description3 	VARCHAR(280),   
    IN proc_XP3			 	INT,       
    IN proc_description2 	VARCHAR(280),   
    IN proc_XP2			 	INT,           
    IN proc_description1 	VARCHAR(280),   
    IN proc_XP1			 	INT,
	IN proc_blob			VARCHAR(2048),
	IN proc_blobtitle		VARCHAR(40),
    IN proc_blobdescription	VARCHAR(120)
)
BEGIN
    DECLARE quest_is_used BOOLEAN;
    DECLARE IDbadge		   INT;
	DECLARE IDsecond_quest INT;
    DECLARE IDfirst_quest  INT;
    
	-- o admin deve escolher a terceira missão sempre, 
    -- aí pegamos a segunda e primeira em sequência
	SET IDsecond_quest = proc_IDquest - 1;
    SET IDfirst_quest  = proc_IDquest - 2;
    
	SELECT fk_badge_quest INTO IDbadge 
	FROM tbl_quest WHERE pk_IDquest = proc_IDquest;
    
	IF IDbadge IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'A missão selecionada não é a última em uma cadeia de missões(3 em 3).';
    END IF;
    
    SELECT COUNT(*) INTO quest_is_used
    FROM tbl_user
    WHERE fk_quest_user IN (proc_IDquest, IDsecond_quest, IDfirst_quest);
    
	IF quest_is_used > 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Não é possível modificar quests e badge que já estão sendo usadas.';
    END IF;
        
    -- Atualiza as missões
    UPDATE tbl_quest
    SET
        description_quest = IFNULL(proc_description3, description_quest),
        XP_quest 		  = IFNULL(proc_XP3, XP_quest)
    WHERE pk_IDquest = proc_IDquest;

    UPDATE tbl_quest
    SET
        description_quest = IFNULL(proc_description2, description_quest),
        XP_quest 		  = IFNULL(proc_XP2, XP_quest)
    WHERE pk_IDquest = IDsecond_quest;

    UPDATE tbl_quest
    SET
        description_quest = IFNULL(proc_description1, description_quest),
        XP_quest 		  = IFNULL(proc_XP1, XP_quest)
    WHERE pk_IDquest = IDfirst_quest;
    
	-- Atualiza a badge
	UPDATE tbl_badge
    SET 
        blob_badge 		  = IFNULL(proc_blob, blob_badge),
        title_badge 	  = IFNULL(proc_blobtitle, title_badge),
        description_badge = IFNULL(proc_blobdescription, description_badge)
    WHERE pk_IDbadge = IDbadge;

END //

-- modificação de registro de dica, acesso administrador
CREATE PROCEDURE ModifyTip(
    IN proc_IDtip	  	 INT,
    IN proc_description  VARCHAR(280)

)
BEGIN
    UPDATE tbl_tip
    SET
		description_tip 	= IFNULL(proc_description, description_tip),
        date_tip			= CURRENT_DATE()
	WHERE
		pk_IDtip			= proc_IDtip;
END //

-- exclusão de article, acesso administrador
CREATE PROCEDURE DeleteArticle(
	IN proc_IDarticle INT
)
BEGIN
	DELETE FROM tbl_article
    WHERE pk_IDarticle = proc_IDarticle;
    
END //

-- exclusão de quest e badge, acesso administrador
-- sempre exclui os últimos três quests e a badge associada
CREATE PROCEDURE DeleteQuestAndBadge()
BEGIN
	DECLARE proc_IDbadge	INT;
	DECLARE proc_IDquest	INT;
	DECLARE IDsecond_quest 	INT;
    DECLARE IDfirst_quest  	INT;
    DECLARE quest_is_used	BOOLEAN;
    DECLARE quest_is_down30 BOOLEAN;
    
    -- seleciona o badge mais recente
    SELECT MAX(pk_IDbadge) INTO proc_IDbadge
    FROM tbl_badge;
    
    -- seleciona a missão mais recente
	SELECT MAX(pk_IDquest) INTO proc_IDquest
	FROM tbl_quest;        
    
	SET IDsecond_quest = proc_IDquest - 1;
    SET IDfirst_quest  = proc_IDquest - 2;
    
    SELECT COUNT(*) INTO quest_is_down30
    FROM tbl_quest;
    
	IF quest_is_down30 <= 30 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível excluir quests padrões.';
    END IF;
    
    SELECT COUNT(*) INTO quest_is_used
    FROM tbl_user
    WHERE fk_quest_user IN (proc_IDquest, IDsecond_quest, IDfirst_quest);
    
	IF quest_is_used > 0 THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Não é possível excluir quests sendo usadas.';
    END IF;
    
    DELETE FROM tbl_quest 
    WHERE pk_IDquest IN (proc_IDquest, IDsecond_quest, IDfirst_quest);
    
    DELETE FROM tbl_badge
    WHERE pk_IDbadge = proc_IDbadge;

END //

-- exclusão de level, acesso administrador
-- sempre exclui o último level
CREATE PROCEDURE DeleteLevel()
BEGIN
	DECLARE proc_IDlevel    INT;
	DECLARE level_is_down40	BOOLEAN;
    DECLARE level_is_used	BOOLEAN;
    
	SELECT MAX(pk_IDlevel) INTO proc_IDlevel
    FROM tbl_level;
    
    SELECT CASE
               WHEN pk_IDlevel <= 40 THEN TRUE
               ELSE FALSE
           END INTO level_is_down40
    FROM tbl_level
    WHERE pk_IDlevel = proc_IDlevel;

    IF level_is_down40 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível excluir um level fixo.';
    END IF;
    
    SELECT COUNT(*) INTO level_is_used
    FROM tbl_user
    WHERE fk_level_user = proc_IDlevel;

    IF level_is_used > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível excluir um level ativo.';
    END IF;
    
    DELETE FROM tbl_level
    WHERE pk_IDlevel = proc_IDlevel;
    
END //

-- exclusão de tip, acesso administrador
CREATE PROCEDURE DeleteTip(
	IN proc_IDtip	INT
)
BEGIN
	DELETE FROM tbl_tip
    WHERE pk_IDtip = proc_IDtip;
    
END //

DELIMITER ;