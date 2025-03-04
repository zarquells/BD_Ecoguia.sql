USE bd_ecoguia;

-- Views abaixo para comandos padrões de visualização estática ou com poucas condições:
-- ¨¨Visualizar registros do sistema.
DELIMITER //
-- view de todos os artigos, acesso sistema
CREATE VIEW ViewAllArticle AS
SELECT *
FROM tbl_article //

-- view de avatar para seleção, acesso sistema
CREATE VIEW ViewAllAvatar AS
SELECT * 
FROM tbl_avatar //

-- view de levels, acesso sistema
CREATE VIEW ViewAllLevel AS
SELECT *
FROM tbl_level //

-- view de material, acesso sistema
CREATE VIEW ViewAllMaterial AS
SELECT *
FROM tbl_material //

-- view de quest para carregar o mapa, acesso sistema
CREATE VIEW ViewAllQuest AS
SELECT q.*, b.*
FROM tbl_quest q
LEFT JOIN tbl_badge b ON q.fk_badge_quest = b.pk_IDbadge //

-- view de todas as dicas, acesso sistema
CREATE VIEW ViewAllTips AS
SELECT *
FROM tbl_tip//

-- view de dicas, acesso sistema
CREATE VIEW ViewRandomTip AS
SELECT * 
FROM tbl_tip
ORDER BY RAND() LIMIT 1//

-- view de última badge, acesso administrador
CREATE VIEW ViewLatestBadge AS
SELECT blob_badge 
FROM tbl_badge
WHERE pk_IDbadge = (
    SELECT MAX(pk_IDbadge) 
    FROM tbl_badge
)//

 -- view para pegar todos os IDs, nicknames e XPs, acesso usuário
CREATE VIEW ViewAllNicknames AS
SELECT pk_IDuser, fk_avatar_user, nickname_user, XP_user 
FROM tbl_user //

 -- view para pegar todos os emails, acesso usuário
 CREATE VIEW ViewAllEmails AS
 SELECT pk_IDuser, email_user AS email, password_user AS pwd
 FROM tbl_user //
 
 -- view para pegar todos os emails, acesso admin
 CREATE VIEW ViewAllAdmins AS 
 SELECT pk_IDadmin, email_admin AS email, password_admin AS pwd
 FROM tbl_admin //

DELIMITER ;