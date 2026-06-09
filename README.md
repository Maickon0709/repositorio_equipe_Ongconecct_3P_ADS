# 🌱 Sistema de Gestão de ONGs

Sistema de banco de dados relacional desenvolvido para apoiar a gestão de Organizações Não-Governamentais, permitindo o controle integrado de projetos sociais, doações, voluntários, beneficiários e recursos.

---

## 📋 Sobre o Projeto

Este projeto foi desenvolvido como trabalho acadêmico em três entregas progressivas, cobrindo desde a modelagem conceitual até a implementação física do banco de dados.

O sistema permite que ONGs gerenciem de forma centralizada:
- Seus projetos sociais e o público atendido
- O cadastro e acompanhamento de voluntários
- O recebimento e rastreamento de doações
- A alocação de recursos por projeto
- O histórico de atendimento a beneficiários

---

## 🗃️ Estrutura do Banco de Dados

O banco é composto por **10 tabelas**, **5 views** e **triggers de auditoria**.

### Tabelas principais

| Tabela | Descrição |
|---|---|
| `ong` | Cadastro das organizações |
| `projeto` | Projetos sociais vinculados às ONGs |
| `beneficiario` | Pessoas atendidas pelos projetos |
| `voluntario` | Voluntários cadastrados |
| `doador` | Doadores (pessoas físicas e jurídicas) |
| `doacao` | Registro de doações realizadas |
| `recurso` | Catálogo de recursos disponíveis |
| `projeto_beneficiario` | Vínculo N:N entre projetos e beneficiários |
| `voluntario_projeto` | Vínculo N:N entre voluntários e projetos |
| `projeto_recurso` | Alocação de recursos por projeto |

### Views

- `vw_recursos_por_projeto` — Total de recursos utilizados por projeto
- `vw_arrecadacao_por_projeto` — Soma de doações recebidas por projeto
- `vw_voluntarios_por_projeto` — Voluntários ativos e suas funções
- `vw_doadores_fieis` — Doadores com mais de uma doação registrada
- `vw_impacto_por_projeto` — Consolidação de métricas de impacto social

### Triggers

A tabela `doacao` possui triggers que registram automaticamente toda operação (INSERT, UPDATE, DELETE) na tabela `log_doacao`, garantindo rastreabilidade completa das movimentações financeiras.

---

## 📁 Entregas

### Entrega 1 — Modelo Conceitual
Diagrama Entidade-Relacionamento (DER) conceitual com identificação de entidades, atributos e relacionamentos do sistema.

### Entrega 2 — Modelo Lógico
Diagrama Entidade-Relacionamento lógico com definição de chaves primárias, chaves estrangeiras, cardinalidades e tipos de dados de todas as tabelas.

### Entrega 3 — Implementação Física
Scripts SQL de criação do banco de dados, incluindo tabelas, constraints, índices, views e triggers. Acompanha também o **Dicionário de Dados** completo em PDF com a descrição detalhada de cada coluna.

---

## 📄 Dicionário de Dados

O arquivo `dicionario_de_dados.pdf` documenta todas as tabelas do sistema com as seguintes informações por coluna:

- Nome e tipo do campo
- Tamanho/precisão
- Restrição de nulidade
- Chave (PK, FK ou composta)
- Descrição semântica

---

## 🛠️ Tecnologias

- **SGBD:** MySQL
- **Modelagem:** MySQL Workbench
- **Documentação:** Python + ReportLab

---

## 👥 Autores

Desenvolvido como projeto da disciplina de Banco de Dados.
