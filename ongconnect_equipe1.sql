-- ============================================================
--  ONGConnect — Script SQL Completo (Parte 3)
--  Equipe: Maickon H.B. Santos, Gabriel F.S. dos Santos,
--          Arthur Luiz dos Santos Ferreira da Silva
--  Disciplina: Banco de Dados — ADS / Universidade Salgado de Oliveira
--  SGBD: MySQL 8.0
--  Data: 2026
-- ============================================================

-- ============================================================
-- 0. CRIAÇÃO E SELEÇÃO DO BANCO
-- ============================================================
DROP DATABASE IF EXISTS ongconnect;
CREATE DATABASE ongconnect
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE ongconnect;

-- ============================================================
-- 1. SCHEMA COMPLETO — TABELAS NORMALIZADAS (3NF)
-- ============================================================

-- 1.1 ONG
CREATE TABLE ONG (
    id_ong          INT           NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(200)  NOT NULL,
    cnpj            VARCHAR(18)   NOT NULL,
    missao          TEXT,
    area_atuacao    VARCHAR(150),
    data_fundacao   DATE,
    CONSTRAINT pk_ong    PRIMARY KEY (id_ong),
    CONSTRAINT uq_ong_cnpj UNIQUE (cnpj)
) ENGINE=InnoDB;

-- 1.2 Doador
CREATE TABLE Doador (
    id_doador       INT           NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(150)  NOT NULL,
    cpf_cnpj        VARCHAR(18)   NOT NULL,
    email           VARCHAR(100),
    telefone        VARCHAR(20),
    tipo            ENUM('PF','PJ') NOT NULL,
    data_cadastro   DATE          NOT NULL,
    CONSTRAINT pk_doador         PRIMARY KEY (id_doador),
    CONSTRAINT uq_doador_cpfcnpj UNIQUE (cpf_cnpj),
    CONSTRAINT uq_doador_email   UNIQUE (email)
) ENGINE=InnoDB;

-- 1.3 Projeto
CREATE TABLE Projeto (
    id_projeto          INT            NOT NULL AUTO_INCREMENT,
    id_ong              INT            NOT NULL,
    nome                VARCHAR(200)   NOT NULL,
    descricao           TEXT,
    objetivo_social     VARCHAR(300),
    data_inicio         DATE           NOT NULL,
    data_fim            DATE,
    status              ENUM('planejamento','em_andamento','concluido','suspenso')
                        NOT NULL DEFAULT 'planejamento',
    orcamento_previsto  DECIMAL(12,2),
    publico_alvo        VARCHAR(200),
    CONSTRAINT pk_projeto     PRIMARY KEY (id_projeto),
    CONSTRAINT fk_projeto_ong FOREIGN KEY (id_ong) REFERENCES ONG(id_ong)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 1.4 Voluntario
CREATE TABLE Voluntario (
    id_voluntario   INT           NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(150)  NOT NULL,
    cpf             VARCHAR(14)   NOT NULL,
    email           VARCHAR(100),
    habilidades     TEXT,
    disponibilidade VARCHAR(100),
    data_cadastro   DATE,
    CONSTRAINT pk_voluntario     PRIMARY KEY (id_voluntario),
    CONSTRAINT uq_voluntario_cpf UNIQUE (cpf)
) ENGINE=InnoDB;

-- 1.5 Recurso
CREATE TABLE Recurso (
    id_recurso      INT           NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(150)  NOT NULL,
    tipo            ENUM('financeiro','material','equipamento','servico') NOT NULL,
    quantidade      DECIMAL(10,2),
    unidade         VARCHAR(30),
    valor_unitario  DECIMAL(10,2),
    CONSTRAINT pk_recurso PRIMARY KEY (id_recurso)
) ENGINE=InnoDB;

-- 1.6 Doacao
CREATE TABLE Doacao (
    id_doacao       INT             NOT NULL AUTO_INCREMENT,
    id_doador       INT             NOT NULL,
    id_projeto      INT             NOT NULL,
    valor           DECIMAL(12,2)   NOT NULL,
    data_doacao     DATE            NOT NULL,
    tipo            ENUM('financeira','material') NOT NULL,
    comprovante     VARCHAR(100),
    CONSTRAINT pk_doacao           PRIMARY KEY (id_doacao),
    CONSTRAINT fk_doacao_doador    FOREIGN KEY (id_doador)  REFERENCES Doador(id_doador)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_doacao_projeto   FOREIGN KEY (id_projeto) REFERENCES Projeto(id_projeto)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_doacao_valor     CHECK (valor > 0)
) ENGINE=InnoDB;

-- 1.7 Beneficiario
CREATE TABLE Beneficiario (
    id_beneficiario INT           NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(150)  NOT NULL,
    cpf             VARCHAR(14),
    data_nascimento DATE,
    telefone        VARCHAR(20),
    situacao_social TEXT,
    CONSTRAINT pk_beneficiario     PRIMARY KEY (id_beneficiario),
    CONSTRAINT uq_beneficiario_cpf UNIQUE (cpf)
) ENGINE=InnoDB;

-- 1.8 Voluntario_Projeto (N:M)
CREATE TABLE Voluntario_Projeto (
    id_projeto      INT          NOT NULL,
    id_voluntario   INT          NOT NULL,
    funcao          VARCHAR(100),
    data_inicio     DATE,
    data_fim        DATE,
    CONSTRAINT pk_vol_proj          PRIMARY KEY (id_projeto, id_voluntario),
    CONSTRAINT fk_volproj_projeto   FOREIGN KEY (id_projeto)    REFERENCES Projeto(id_projeto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_volproj_vol       FOREIGN KEY (id_voluntario) REFERENCES Voluntario(id_voluntario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 1.9 Projeto_Recurso (N:M)
CREATE TABLE Projeto_Recurso (
    id_projeto          INT            NOT NULL,
    id_recurso          INT            NOT NULL,
    quantidade_utilizada DECIMAL(10,2),
    data_alocacao       DATE,
    observacao          VARCHAR(255),
    CONSTRAINT pk_proj_rec           PRIMARY KEY (id_projeto, id_recurso),
    CONSTRAINT fk_projrec_projeto    FOREIGN KEY (id_projeto) REFERENCES Projeto(id_projeto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_projrec_recurso    FOREIGN KEY (id_recurso) REFERENCES Recurso(id_recurso)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 1.10 Projeto_Beneficiario (N:M)
CREATE TABLE Projeto_Beneficiario (
    id_projeto          INT  NOT NULL,
    id_beneficiario     INT  NOT NULL,
    data_atendimento    DATE,
    observacao          VARCHAR(255),
    CONSTRAINT pk_proj_ben           PRIMARY KEY (id_projeto, id_beneficiario),
    CONSTRAINT fk_projben_projeto    FOREIGN KEY (id_projeto)      REFERENCES Projeto(id_projeto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_projben_ben        FOREIGN KEY (id_beneficiario) REFERENCES Beneficiario(id_beneficiario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 2. ÍNDICES PARA RELATÓRIOS DE IMPACTO
-- ============================================================
CREATE INDEX idx_projeto_status      ON Projeto(status);
CREATE INDEX idx_projeto_ong         ON Projeto(id_ong);
CREATE INDEX idx_doacao_data         ON Doacao(data_doacao);
CREATE INDEX idx_doacao_projeto      ON Doacao(id_projeto);
CREATE INDEX idx_doacao_doador       ON Doacao(id_doador);
CREATE INDEX idx_doador_tipo         ON Doador(tipo);
CREATE INDEX idx_beneficiario_cpf    ON Beneficiario(cpf);
CREATE INDEX idx_voluntario_cpf      ON Voluntario(cpf);
CREATE INDEX idx_projben_beneficiario ON Projeto_Beneficiario(id_beneficiario);

-- ============================================================
-- 3. LOG AUXILIAR PARA TRIGGER
-- ============================================================
CREATE TABLE Log_Doacao (
    id_log          INT           NOT NULL AUTO_INCREMENT,
    id_doacao       INT,
    id_doador       INT,
    id_projeto      INT,
    valor           DECIMAL(12,2),
    tipo_operacao   ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    data_operacao   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_log_doacao PRIMARY KEY (id_log)
) ENGINE=InnoDB;

-- ============================================================
-- 4. TRIGGERS PARA RASTREAMENTO DE DOAÇÕES
-- ============================================================
DELIMITER $$

-- 4.1 Trigger AFTER INSERT — registra nova doação
CREATE TRIGGER trg_doacao_insert
AFTER INSERT ON Doacao
FOR EACH ROW
BEGIN
    INSERT INTO Log_Doacao (id_doacao, id_doador, id_projeto, valor, tipo_operacao)
    VALUES (NEW.id_doacao, NEW.id_doador, NEW.id_projeto, NEW.valor, 'INSERT');
END$$

-- 4.2 Trigger AFTER UPDATE — rastreia alteração de valor
CREATE TRIGGER trg_doacao_update
AFTER UPDATE ON Doacao
FOR EACH ROW
BEGIN
    INSERT INTO Log_Doacao (id_doacao, id_doador, id_projeto, valor, tipo_operacao)
    VALUES (NEW.id_doacao, NEW.id_doador, NEW.id_projeto, NEW.valor, 'UPDATE');
END$$

-- 4.3 Trigger AFTER DELETE — registra exclusão lógica
CREATE TRIGGER trg_doacao_delete
AFTER DELETE ON Doacao
FOR EACH ROW
BEGIN
    INSERT INTO Log_Doacao (id_doacao, id_doador, id_projeto, valor, tipo_operacao)
    VALUES (OLD.id_doacao, OLD.id_doador, OLD.id_projeto, OLD.valor, 'DELETE');
END$$

DELIMITER ;

-- ============================================================
-- 5. VIEWS PARA DASHBOARDS GERENCIAIS
-- ============================================================

-- 5.1 Total arrecadado por projeto
CREATE VIEW vw_arrecadacao_por_projeto AS
SELECT
    p.id_projeto,
    p.nome          AS projeto,
    o.nome          AS ong,
    p.status,
    p.orcamento_previsto,
    COALESCE(SUM(d.valor), 0)   AS total_arrecadado,
    COUNT(d.id_doacao)          AS qtd_doacoes
FROM Projeto p
JOIN ONG o ON o.id_ong = p.id_ong
LEFT JOIN Doacao d ON d.id_projeto = p.id_projeto
GROUP BY p.id_projeto, p.nome, o.nome, p.status, p.orcamento_previsto;

-- 5.2 Doadores fiéis (mais de 1 doação)
CREATE VIEW vw_doadores_fieis AS
SELECT
    d.id_doador,
    d.nome,
    d.tipo,
    COUNT(dc.id_doacao)      AS total_doacoes,
    SUM(dc.valor)            AS valor_total_doado,
    MAX(dc.data_doacao)      AS ultima_doacao
FROM Doador d
JOIN Doacao dc ON dc.id_doador = d.id_doador
GROUP BY d.id_doador, d.nome, d.tipo
HAVING COUNT(dc.id_doacao) > 1
ORDER BY valor_total_doado DESC;

-- 5.3 Impacto social — beneficiários por projeto
CREATE VIEW vw_impacto_por_projeto AS
SELECT
    p.id_projeto,
    p.nome              AS projeto,
    o.nome              AS ong,
    p.publico_alvo,
    COUNT(pb.id_beneficiario) AS total_beneficiarios
FROM Projeto p
JOIN ONG o ON o.id_ong = p.id_ong
LEFT JOIN Projeto_Beneficiario pb ON pb.id_projeto = p.id_projeto
GROUP BY p.id_projeto, p.nome, o.nome, p.publico_alvo;

-- 5.4 Voluntários ativos por projeto
CREATE VIEW vw_voluntarios_por_projeto AS
SELECT
    p.nome   AS projeto,
    v.nome   AS voluntario,
    vp.funcao,
    vp.data_inicio,
    vp.data_fim
FROM Voluntario_Projeto vp
JOIN Projeto    p ON p.id_projeto    = vp.id_projeto
JOIN Voluntario v ON v.id_voluntario = vp.id_voluntario;

-- 5.5 Recursos alocados por projeto
CREATE VIEW vw_recursos_por_projeto AS
SELECT
    p.nome              AS projeto,
    r.nome              AS recurso,
    r.tipo,
    pr.quantidade_utilizada,
    r.unidade,
    r.valor_unitario,
    (pr.quantidade_utilizada * r.valor_unitario) AS custo_estimado
FROM Projeto_Recurso pr
JOIN Projeto p ON p.id_projeto = pr.id_projeto
JOIN Recurso r ON r.id_recurso = pr.id_recurso;

-- ============================================================
-- 6. DADOS DE TESTE REALISTAS (mínimo 50 registros)
-- ============================================================

-- 6.1 ONGs (3)
INSERT INTO ONG (nome, cnpj, missao, area_atuacao, data_fundacao) VALUES
('Instituto Recife Solidário',   '12.345.678/0001-90', 'Promover inclusão social e educação em comunidades vulneráveis de Recife.', 'Educação e Assistência Social', '2005-03-15'),
('Mãos Abertas PE',              '98.765.432/0001-11', 'Apoiar crianças e adolescentes em situação de risco através de cultura e esporte.', 'Infância e Juventude',          '2010-07-22'),
('Verde Vivo Pernambuco',        '55.111.222/0001-33', 'Preservação ambiental e educação ecológica nas comunidades do Grande Recife.',   'Meio Ambiente',                 '2015-11-01');

-- 6.2 Doadores (10)
INSERT INTO Doador (nome, cpf_cnpj, email, telefone, tipo, data_cadastro) VALUES
('Ana Paula Ferreira',     '111.222.333-44', 'ana.paula@email.com',    '81 9 9001-1001', 'PF', '2024-01-10'),
('Carlos Eduardo Lima',    '222.333.444-55', 'carlos.lima@email.com',  '81 9 9002-2002', 'PF', '2024-02-15'),
('Empresa TechPE Ltda',    '33.444.555/0001-66', 'contato@techpe.com.br', '81 3300-4400', 'PJ', '2024-03-01'),
('Fernanda Costa Sousa',   '444.555.666-77', 'fernanda.cs@email.com',  '81 9 9003-3003', 'PF', '2024-04-05'),
('Grupo Construa PE',      '55.666.777/0001-88', 'admin@construape.com.br','81 3500-6600','PJ', '2024-05-20'),
('José Marcos Oliveira',   '666.777.888-99', 'jose.marcos@email.com',  '81 9 9004-4004', 'PF', '2024-06-10'),
('Márcia Renata Nunes',    '777.888.999-00', 'marcia.nunes@email.com', '81 9 9005-5005', 'PF', '2024-07-14'),
('Supermercado Bom Preço', '88.999.000/0001-22', 'rh@bompreco.com.br', '81 3200-1100',   'PJ', '2024-08-01'),
('Ricardo Alves Dias',     '999.000.111-33', 'ricardo.dias@email.com', '81 9 9006-6006', 'PF', '2024-09-18'),
('Patrícia Lemos Barros',  '000.111.222-44', 'patricia.lb@email.com',  '81 9 9007-7007', 'PF', '2024-10-02');

-- 6.3 Projetos (6)
INSERT INTO Projeto (id_ong, nome, descricao, objetivo_social, data_inicio, data_fim, status, orcamento_previsto, publico_alvo) VALUES
(1, 'Reforço Escolar Recife',     'Aulas de reforço em matemática e português para crianças da rede pública.',  'Melhorar desempenho escolar de crianças vulneráveis.',            '2025-02-01', '2025-12-15', 'em_andamento', 45000.00,  'Crianças de 7 a 14 anos'),
(1, 'Capacitação Digital Adultos','Cursos de informática e internet para adultos desempregados.',                'Inserção no mercado de trabalho digital.',                         '2025-04-01', '2025-10-31', 'em_andamento', 30000.00,  'Adultos acima de 18 anos'),
(2, 'Esporte na Periferia',       'Atividades esportivas semanais para jovens em situação de vulnerabilidade.', 'Afastar jovens da violência por meio do esporte.',                 '2025-01-10', '2025-12-20', 'em_andamento', 25000.00,  'Jovens de 12 a 18 anos'),
(2, 'Arte e Cultura Viva',        'Oficinas de teatro, música e artes plásticas para crianças e adolescentes.', 'Desenvolvimento socioemocional por meio da arte.',                 '2025-03-01', '2025-11-30', 'em_andamento', 20000.00,  'Crianças e adolescentes'),
(3, 'Horta Comunitária',          'Implantação de hortas em escolas públicas da periferia de Recife.',          'Segurança alimentar e educação ambiental.',                        '2025-02-15', '2025-09-30', 'concluido',    15000.00,  'Comunidades de baixa renda'),
(3, 'Reflorestamento Urbano',     'Plantio de mudas nativas em áreas degradadas do Recife.',                   'Recuperação de áreas verdes e conscientização ambiental.',         '2025-05-01', '2026-04-30', 'planejamento', 60000.00,  'População geral');

-- 6.4 Voluntários (10)
INSERT INTO Voluntario (nome, cpf, email, habilidades, disponibilidade, data_cadastro) VALUES
('Lucas Mendes Albuquerque',  '100.200.300-01', 'lucas.ma@email.com',    'Pedagogia, reforço escolar, didática',           'Sábados e domingos',      '2025-01-05'),
('Isabela Torres Gomes',      '200.300.400-02', 'isa.torres@email.com',  'Informática, Excel, Python básico',              'Fins de semana',          '2025-01-20'),
('Felipe Rocha Bezerra',      '300.400.500-03', 'felipe.rb@email.com',   'Educação física, futebol, basquete',             'Segundas e quartas',      '2025-02-01'),
('Amanda Cristina Freitas',   '400.500.600-04', 'amanda.cf@email.com',   'Teatro, música, artes plásticas',                'Terças e quintas',        '2025-02-10'),
('Thiago Souza Cavalcante',   '500.600.700-05', 'thiago.sc@email.com',   'Agronomia, horta, compostagem',                  'Fins de semana',          '2025-02-15'),
('Juliana Mota Pinheiro',     '600.700.800-06', 'juli.mota@email.com',   'Biologia, educação ambiental, reflorestamento',  'Qualquer dia',            '2025-03-01'),
('Rodrigo Nascimento Lima',   '700.800.900-07', 'rodrigo.nl@email.com',  'Matemática, física, reforço escolar',            'Sábados',                 '2025-03-10'),
('Camila Estevam Vieira',     '800.900.000-08', 'camila.ev@email.com',   'Design gráfico, fotografia, redes sociais',      'Domingos',                '2025-03-15'),
('Bruno Henrique Correia',    '900.000.100-09', 'bruno.hc@email.com',    'Psicologia, apoio socioemocional',               'Terças e quintas',        '2025-04-01'),
('Natália Ramos da Cruz',     '010.020.030-10', 'natalia.rc@email.com',  'Nutrição, educação alimentar, saúde pública',    'Sábados e domingos',      '2025-04-10');

-- 6.5 Recursos (8)
INSERT INTO Recurso (nome, tipo, quantidade, unidade, valor_unitario) VALUES
('Notebook usado',          'equipamento', 20.00,  'unidade',  800.00),
('Datashow',                'equipamento',  5.00,  'unidade', 1500.00),
('Material escolar kit',    'material',   100.00,  'kit',       35.00),
('Bola de futebol',         'material',    15.00,  'unidade',   80.00),
('Kit jardinagem',          'material',    30.00,  'kit',       60.00),
('Muda nativa (ipê-amarelo)','material',  500.00,  'muda',       8.00),
('Transporte voluntários',  'servico',     50.00,  'viagem',   120.00),
('Verba geral projetos',    'financeiro',   1.00,  'R$',     10000.00);

-- 6.6 Doações (15)
INSERT INTO Doacao (id_doador, id_projeto, valor, data_doacao, tipo, comprovante) VALUES
(1,  1, 2000.00, '2025-02-05', 'financeira', 'COMP-001.pdf'),
(2,  1, 1500.00, '2025-02-20', 'financeira', 'COMP-002.pdf'),
(3,  1, 8000.00, '2025-03-01', 'financeira', 'COMP-003.pdf'),
(4,  2, 1000.00, '2025-04-10', 'financeira', 'COMP-004.pdf'),
(5,  2, 5000.00, '2025-04-15', 'financeira', 'COMP-005.pdf'),
(6,  3, 3000.00, '2025-01-15', 'financeira', 'COMP-006.pdf'),
(7,  3, 1200.00, '2025-02-01', 'financeira', 'COMP-007.pdf'),
(8,  4,  800.00, '2025-03-10', 'material',   'COMP-008.pdf'),
(9,  5, 2500.00, '2025-02-20', 'financeira', 'COMP-009.pdf'),
(10, 5,  500.00, '2025-03-05', 'material',   'COMP-010.pdf'),
(1,  6, 3000.00, '2025-05-10', 'financeira', 'COMP-011.pdf'),
(3,  6,15000.00, '2025-05-15', 'financeira', 'COMP-012.pdf'),
(5,  3, 2000.00, '2025-06-01', 'financeira', 'COMP-013.pdf'),
(2,  2,  750.00, '2025-06-10', 'financeira', 'COMP-014.pdf'),
(4,  1, 1800.00, '2025-06-20', 'financeira', 'COMP-015.pdf');

-- 6.7 Beneficiários (12)
INSERT INTO Beneficiario (nome, cpf, data_nascimento, telefone, situacao_social) VALUES
('Pedro Henrique da Silva',      '111.000.999-01', '2012-05-10', '81 9 8001-0001', 'Família em situação de vulnerabilidade; responsável desempregado.'),
('Maria Clara Santana',          '222.001.888-02', '2013-08-22', '81 9 8002-0002', 'Criança em risco social; mora em área de conflito.'),
('João Victor Oliveira',         '333.002.777-03', '2011-11-30', '81 9 8003-0003', 'Sem acesso a materiais escolares; renda familiar baixa.'),
('Luiza Beatriz Ferreira',       '444.003.666-04', '2015-03-15', '81 9 8004-0004', 'Família monoparental; mãe com renda informal.'),
('Gabriel Augusto Pereira',      '555.004.555-05', '2010-07-04', '81 9 8005-0005', 'Adolescente em acompanhamento pelo CRAS local.'),
('Yasmin Cristine Rodrigues',    '666.005.444-06', '2014-12-19', '81 9 8006-0006', 'Criança com histórico de evasão escolar.'),
('Rafael Sousa Bezerra',         '777.006.333-07', '2009-09-09', '81 9 8007-0007', 'Jovem em risco; histórico de envolvimento com violência.'),
('Ane Caroline Mendes',          '888.007.222-08', '2008-04-27', '81 9 8008-0008', 'Adolescente em situação de trabalho informal.'),
('Antônio Carlos Lima',          NULL,             '1975-01-18', '81 9 8009-0009', 'Adulto desempregado; busca requalificação profissional.'),
('Conceição Aparecida Santos',   NULL,             '1968-06-30', '81 9 8010-0010', 'Idosa em situação de insegurança alimentar.'),
('Marcos Vinicius Albuquerque',  '101.008.111-11', '2007-02-14', '81 9 8011-0011', 'Adolescente com dificuldades de aprendizagem.'),
('Tatiana Medeiros Costa',       '202.009.000-12', '2012-10-05', '81 9 8012-0012', 'Criança em comunidade sem saneamento básico.');

-- 6.8 Voluntario_Projeto
INSERT INTO Voluntario_Projeto (id_projeto, id_voluntario, funcao, data_inicio, data_fim) VALUES
(1, 1, 'Professor de Matemática',     '2025-02-01', '2025-12-15'),
(1, 7, 'Professor de Matemática',     '2025-03-10', '2025-12-15'),
(2, 2, 'Instrutor de Informática',    '2025-04-01', '2025-10-31'),
(3, 3, 'Técnico de Futebol',          '2025-01-10', '2025-12-20'),
(4, 4, 'Coordenadora de Oficinas',    '2025-03-01', '2025-11-30'),
(4, 8, 'Designer Gráfico',            '2025-03-15', '2025-11-30'),
(5, 5, 'Responsável pela Horta',      '2025-02-15', '2025-09-30'),
(5,10, 'Educadora Alimentar',         '2025-02-15', '2025-09-30'),
(6, 6, 'Coordenadora Ambiental',      '2025-05-01', '2026-04-30'),
(1, 9, 'Apoio Socioemocional',        '2025-02-01', '2025-12-15');

-- 6.9 Projeto_Recurso
INSERT INTO Projeto_Recurso (id_projeto, id_recurso, quantidade_utilizada, data_alocacao, observacao) VALUES
(1, 3, 60.00, '2025-02-01', 'Kits distribuídos no início do projeto'),
(1, 2,  2.00, '2025-02-01', 'Datashows para aulas expositivas'),
(2, 1, 15.00, '2025-04-01', 'Notebooks para os alunos do curso'),
(2, 2,  2.00, '2025-04-01', 'Datashow para apresentações'),
(3, 4, 10.00, '2025-01-10', 'Bolas para treinos semanais'),
(4, 3, 20.00, '2025-03-01', 'Kits de material para oficinas'),
(5, 5, 20.00, '2025-02-15', 'Kits de jardinagem para implantação'),
(5, 8,  1.00, '2025-02-15', 'Verba inicial do projeto'),
(6, 6,300.00, '2025-05-01', 'Mudas para o primeiro plantio'),
(6, 7, 20.00, '2025-05-01', 'Viagens para transporte da equipe');

-- 6.10 Projeto_Beneficiario
INSERT INTO Projeto_Beneficiario (id_projeto, id_beneficiario, data_atendimento, observacao) VALUES
(1,  1, '2025-02-05', 'Matriculado no reforço de matemática'),
(1,  2, '2025-02-05', 'Matriculada no reforço de português'),
(1,  3, '2025-02-10', 'Necessita de material escolar'),
(1,  4, '2025-02-10', 'Participação regular'),
(1, 11, '2025-03-10', 'Dificuldade em álgebra — acompanhamento especial'),
(2,  9, '2025-04-05', 'Inscrito no curso de informática básica'),
(3,  5, '2025-01-15', 'Participação em treinos de futebol'),
(3,  7, '2025-01-15', 'Jovem em acompanhamento psicossocial'),
(3,  8, '2025-02-01', 'Frequência regular'),
(4,  6, '2025-03-05', 'Oficina de teatro — excelente engajamento'),
(4, 12, '2025-03-05', 'Oficina de artes plásticas'),
(5, 10, '2025-02-20', 'Beneficiária da horta — recebe verduras semanalmente'),
(1,  6, '2025-04-01', 'Incluída após evasão escolar identificada'),
(3,  1, '2025-04-15', 'Também participa de atividades esportivas'),
(4,  5, '2025-05-01', 'Inclusão nas oficinas de música');

-- ============================================================
-- 7. 15 CONSULTAS SQL COMPLEXAS PARA RELATÓRIOS SOCIAIS
-- ============================================================

-- CONSULTA 1: Relatório geral de arrecadação por projeto
-- Exibe total arrecadado, quantidade de doações e % do orçamento atingido
SELECT
    p.id_projeto,
    p.nome                                                      AS projeto,
    o.nome                                                      AS ong,
    p.status,
    p.orcamento_previsto,
    COALESCE(SUM(d.valor), 0)                                   AS total_arrecadado,
    COUNT(d.id_doacao)                                          AS qtd_doacoes,
    ROUND(COALESCE(SUM(d.valor),0) / p.orcamento_previsto * 100, 2) AS pct_orcamento
FROM Projeto p
JOIN ONG o ON o.id_ong = p.id_ong
LEFT JOIN Doacao d ON d.id_projeto = p.id_projeto
GROUP BY p.id_projeto, p.nome, o.nome, p.status, p.orcamento_previsto
ORDER BY total_arrecadado DESC;

-- CONSULTA 2: Doadores fiéis — realizaram mais de 1 doação
SELECT
    doa.nome,
    doa.tipo,
    COUNT(d.id_doacao)   AS total_doacoes,
    SUM(d.valor)         AS valor_total,
    MIN(d.data_doacao)   AS primeira_doacao,
    MAX(d.data_doacao)   AS ultima_doacao
FROM Doador doa
JOIN Doacao d ON d.id_doador = doa.id_doador
GROUP BY doa.id_doador, doa.nome, doa.tipo
HAVING COUNT(d.id_doacao) > 1
ORDER BY valor_total DESC;

-- CONSULTA 3: Impacto social — total de beneficiários únicos por ONG
SELECT
    o.nome                          AS ong,
    COUNT(DISTINCT pb.id_beneficiario) AS total_beneficiarios_unicos
FROM ONG o
JOIN Projeto p ON p.id_ong = o.id_ong
JOIN Projeto_Beneficiario pb ON pb.id_projeto = p.id_projeto
GROUP BY o.id_ong, o.nome
ORDER BY total_beneficiarios_unicos DESC;

-- CONSULTA 4: Projetos com mais voluntários ativos
SELECT
    p.nome              AS projeto,
    o.nome              AS ong,
    p.status,
    COUNT(vp.id_voluntario) AS total_voluntarios
FROM Projeto p
JOIN ONG o ON o.id_ong = p.id_ong
LEFT JOIN Voluntario_Projeto vp ON vp.id_projeto = p.id_projeto
GROUP BY p.id_projeto, p.nome, o.nome, p.status
ORDER BY total_voluntarios DESC;

-- CONSULTA 5: Custo total de recursos por projeto
SELECT
    p.nome                                          AS projeto,
    SUM(pr.quantidade_utilizada * r.valor_unitario) AS custo_total_recursos,
    p.orcamento_previsto,
    ROUND(SUM(pr.quantidade_utilizada * r.valor_unitario)
          / p.orcamento_previsto * 100, 2)          AS pct_orcamento_consumido
FROM Projeto p
JOIN Projeto_Recurso pr ON pr.id_projeto = p.id_projeto
JOIN Recurso r ON r.id_recurso = pr.id_recurso
WHERE p.orcamento_previsto IS NOT NULL
GROUP BY p.id_projeto, p.nome, p.orcamento_previsto
ORDER BY custo_total_recursos DESC;

-- CONSULTA 6: Evolução mensal de doações (linha do tempo financeira)
SELECT
    DATE_FORMAT(d.data_doacao, '%Y-%m')  AS mes_ano,
    COUNT(d.id_doacao)                   AS qtd_doacoes,
    SUM(d.valor)                         AS total_arrecadado,
    AVG(d.valor)                         AS ticket_medio
FROM Doacao d
GROUP BY DATE_FORMAT(d.data_doacao, '%Y-%m')
ORDER BY mes_ano;

-- CONSULTA 7: Ranking de doadores por valor total doado
SELECT
    ROW_NUMBER() OVER (ORDER BY SUM(d.valor) DESC) AS ranking,
    doa.nome,
    doa.tipo,
    SUM(d.valor)        AS total_doado,
    COUNT(d.id_doacao)  AS num_doacoes
FROM Doador doa
JOIN Doacao d ON d.id_doador = doa.id_doador
GROUP BY doa.id_doador, doa.nome, doa.tipo
ORDER BY total_doado DESC;

-- CONSULTA 8: Voluntários que atuam em mais de 1 projeto (multi-projeto)
SELECT
    v.nome,
    v.habilidades,
    COUNT(vp.id_projeto) AS projetos_ativos
FROM Voluntario v
JOIN Voluntario_Projeto vp ON vp.id_voluntario = v.id_voluntario
GROUP BY v.id_voluntario, v.nome, v.habilidades
HAVING COUNT(vp.id_projeto) > 1
ORDER BY projetos_ativos DESC;

-- CONSULTA 9: Beneficiários atendidos por múltiplos projetos (histórico de atendimentos)
SELECT
    b.nome,
    b.situacao_social,
    COUNT(pb.id_projeto)  AS projetos_atendidos,
    GROUP_CONCAT(p.nome ORDER BY p.nome SEPARATOR ' | ') AS lista_projetos
FROM Beneficiario b
JOIN Projeto_Beneficiario pb ON pb.id_beneficiario = b.id_beneficiario
JOIN Projeto p ON p.id_projeto = pb.id_projeto
GROUP BY b.id_beneficiario, b.nome, b.situacao_social
ORDER BY projetos_atendidos DESC;

-- CONSULTA 10: Projetos sem nenhuma doação registrada
SELECT
    p.id_projeto,
    p.nome      AS projeto,
    o.nome      AS ong,
    p.status,
    p.orcamento_previsto
FROM Projeto p
JOIN ONG o ON o.id_ong = p.id_ong
WHERE NOT EXISTS (
    SELECT 1 FROM Doacao d WHERE d.id_projeto = p.id_projeto
);

-- CONSULTA 11: Comparativo entre orçamento previsto e total arrecadado + custo recursos
SELECT
    p.nome                                              AS projeto,
    p.orcamento_previsto,
    COALESCE(SUM(DISTINCT d_agg.total_doado), 0)        AS total_doado,
    COALESCE(SUM(pr.quantidade_utilizada * r.valor_unitario), 0) AS custo_recursos,
    (p.orcamento_previsto
        - COALESCE(SUM(DISTINCT d_agg.total_doado), 0)
        + COALESCE(SUM(pr.quantidade_utilizada * r.valor_unitario), 0)) AS saldo_estimado
FROM Projeto p
LEFT JOIN Projeto_Recurso pr ON pr.id_projeto = p.id_projeto
LEFT JOIN Recurso r ON r.id_recurso = pr.id_recurso
LEFT JOIN (
    SELECT id_projeto, SUM(valor) AS total_doado
    FROM Doacao
    GROUP BY id_projeto
) d_agg ON d_agg.id_projeto = p.id_projeto
GROUP BY p.id_projeto, p.nome, p.orcamento_previsto;

-- CONSULTA 12: Relatório de doações por tipo (financeira vs material) por projeto
SELECT
    p.nome                  AS projeto,
    d.tipo                  AS tipo_doacao,
    COUNT(d.id_doacao)      AS qtd,
    SUM(d.valor)            AS total_valor
FROM Doacao d
JOIN Projeto p ON p.id_projeto = d.id_projeto
GROUP BY p.id_projeto, p.nome, d.tipo
ORDER BY p.nome, d.tipo;

-- CONSULTA 13: Habilidades mais frequentes entre voluntários (word count simplificado)
SELECT
    v.habilidades,
    COUNT(vp.id_projeto) AS projetos_envolvidos,
    v.nome
FROM Voluntario v
JOIN Voluntario_Projeto vp ON vp.id_voluntario = v.id_voluntario
GROUP BY v.id_voluntario, v.nome, v.habilidades
ORDER BY projetos_envolvidos DESC;

-- CONSULTA 14: Projetos em andamento com baixo percentual de arrecadação (<50%)
SELECT
    p.nome,
    p.orcamento_previsto,
    COALESCE(SUM(d.valor), 0)                                       AS total_arrecadado,
    ROUND(COALESCE(SUM(d.valor), 0) / p.orcamento_previsto * 100, 1) AS pct_arrecadado
FROM Projeto p
LEFT JOIN Doacao d ON d.id_projeto = p.id_projeto
WHERE p.status = 'em_andamento'
  AND p.orcamento_previsto IS NOT NULL
GROUP BY p.id_projeto, p.nome, p.orcamento_previsto
HAVING pct_arrecadado < 50
ORDER BY pct_arrecadado ASC;

-- CONSULTA 15: Dashboard geral — resumo executivo por ONG
SELECT
    o.nome                                              AS ong,
    o.area_atuacao,
    COUNT(DISTINCT p.id_projeto)                        AS total_projetos,
    SUM(CASE WHEN p.status = 'em_andamento' THEN 1 ELSE 0 END) AS projetos_ativos,
    COUNT(DISTINCT pb.id_beneficiario)                  AS beneficiarios_unicos,
    COUNT(DISTINCT vp.id_voluntario)                    AS voluntarios_envolvidos,
    COALESCE(SUM(d.valor), 0)                           AS total_arrecadado
FROM ONG o
LEFT JOIN Projeto p               ON p.id_ong              = o.id_ong
LEFT JOIN Projeto_Beneficiario pb ON pb.id_projeto         = p.id_projeto
LEFT JOIN Voluntario_Projeto vp   ON vp.id_projeto         = p.id_projeto
LEFT JOIN Doacao d                ON d.id_projeto           = p.id_projeto
GROUP BY o.id_ong, o.nome, o.area_atuacao
ORDER BY total_arrecadado DESC;

-- ============================================================
-- FIM DO SCRIPT
-- ============================================================
-- ONGConnect — ongconnect_equipe1.sql
-- Testado no MySQL 8.0
-- ============================================================
