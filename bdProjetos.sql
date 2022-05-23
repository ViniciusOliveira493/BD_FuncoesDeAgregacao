CREATE DATABASE bdProjetos
GO
USE bdProjetos
CREATE TABLE tbProjects(
	id						INTEGER			IDENTITY(10001,1)	NOT NULL
	,	projectName			VARCHAR(45)							NOT NULL
	,	projectDescription	VARCHAR(45)							
	,	projectDate			DATE								NOT NULL	CHECK(projectDate > '01/09/2014')
	PRIMARY KEY (id)
);
CREATE TABLE tbUsers(
	id						INTEGER			IDENTITY(1,1)		NOT NULL
	,	firstName			VARCHAR(45)							NOT NULL
	,	username			VARCHAR(45)		UNIQUE				NOT NULL
	,	passwd				VARCHAR(45)							NOT	NULL	DEFAULT('123mudar')
	,	email				VARCHAR(45)							NOT	NULL
	PRIMARY KEY (id)
);
CREATE TABLE tbUserHasProjects(
	usersId					INTEGER								NOT NULL
	,	projectsId			INTEGER								NOT NULL
	PRIMARY KEY(usersId,projectsId)	
	FOREIGN KEY (usersId)			REFERENCES tbUsers(id)
	,	FOREIGN KEY (projectsId)	REFERENCES tbProjects(id)
);
--====================================MODIFICAÇÕES============================================
ALTER TABLE tbUsers
DROP CONSTRAINT UQ__tbUsers__F3DBC57207020F21
ALTER TABLE tbUsers
ALTER COLUMN username	VARCHAR(10) NOT NULL
ALTER TABLE tbUsers
ADD CONSTRAINT uniqueUserName UNIQUE (username)

ALTER TABLE tbUsers
ALTER COLUMN passwd			VARCHAR(8)		NOT	NULL
--======================================INSERTS USUÁRIOS================================================
INSERT INTO tbUsers(firstName,username,email)
	VALUES
		('Maria','Rh_maria','maria@empresa.com')
INSERT INTO tbUsers(firstName,username,passwd,email)
	VALUES
		('Paulo','Ti_paulo','123@456','paulo@empresa')
INSERT INTO tbUsers(firstName,username,email)
	VALUES
		('Ana','Rh_ana','ana@empresa.com')
		,('Clara','Ti_clara','clara@empresa.com')
INSERT INTO tbUsers(firstName,username,passwd,email)
	VALUES
		('Aparecido','Rh_apareci','55@!cido','aparecido@empresa.com')

--=======================================INSERTS PROJETOS===============================
INSERT INTO tbProjects(projectName, projectDescription,projectDate)
	VALUES
		('Re-folha','Refatoração das Folhas','05/09/2014')	
		,('Manutenção PC''s','Manutenção PC''s','06/09/2014')
		,('Auditoria',null,'07/09/2014')
--=======================================INSERTS USUARIO_PROJETOS=======================
INSERT INTO tbUserHasProjects(usersId,projectsId)
	VALUES
		(1,10001)
		,(5,10001)
		,(3,10003)
		,(4,10002)
		,(2,10002)
--=======================================ALTERAÇÃO DADOS================================
UPDATE tbProjects
SET projectDate = '12/09/2014'
WHERE id = 10002

UPDATE tbUsers
SET username = 'Rh_cido'
WHERE firstName = 'Aparecido'

UPDATE tbUsers
SET passwd = '888@*'
WHERE username = 'Rh_maria' AND passwd = '123mudar'

DELETE FROM tbUserHasProjects
WHERE usersId = 2 AND projectsId = 10002

--===================
INSERT INTO tbUsers (firstName,username,passwd,email)
	VALUES 
		('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

--==
INSERT INTO tbProjects(projectName,projectDescription,projectDate)
	VALUES
		('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PC''s', '12/09/2014')

--========================== CONSULTAS ===============================
/*
1) Quantos projetos não tem usuários associados a ele. A coluna deve chamar
qty_projects_no_users
*/
SELECT
	COUNT(prj.id) AS qty_projects_no_users
FROM tbProjects AS prj
	LEFT OUTER JOIN tbUserHasProjects AS usrp
		ON prj.id = usrp.projectsId
WHERE usrp.usersId IS NULL
GROUP BY id
/*
2) Id do projeto, nome do projeto, qty_users_project (quantidade de usuários por
projeto) em ordem alfabética crescente pelo nome do projeto
*/
SELECT
	prj.id
	,	prj.projectName AS 'Nome do Projeto'
	,	count(usrp.usersId) AS 'qty_users_project'
FROM tbProjects AS prj
	INNER JOIN tbUserHasProjects AS usrp
		ON usrp.projectsId = prj.id
GROUP BY prj.id,prj.projectName
ORDER BY prj.projectName ASC
		