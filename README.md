

markdown# 🌱 ONGConnect — Sistema de Gestão para ONGs

Projeto acadêmico desenvolvido em 3 entregas progressivas para a disciplina de 
Banco de Dados. O sistema modela e implementa uma solução completa para ONGs 
gerenciarem doadores, projetos, voluntários e recursos.

**SGBD:** MySQL 8.0  
**Ferramentas:** MySQL Workbench · Draw.io · Git/GitHub

---

## 📦 Estrutura do Repositório
repositorio_equipeX/ ├── parte1-MER.pdf ├── parte2-DER.pdf ├── parte2-dicionario.pdf ├── parte3-ongconnect.sql ├── README-equipeX.md └── apresentacao-final.pptx

---

## 📋 Entregas

### Parte 1 — MER (Modelo Entidade-Relacionamento)
**Entregue em:** 11/05/2026 · **Arquivo:** `parte1-MER.pdf`

Documento técnico (8–10 páginas) contendo:
- Identificação das entidades principais do contexto ONG (Doador, Projeto,
  Voluntário, Recurso, Doação, Beneficiário, entre outras)
- Catálogo completo de atributos com tipos de dados e restrições específicas
  do terceiro setor
- Relacionamentos com cardinalidades (doações, voluntariado, execução de
  projetos) — 100% especificadas

---

### Parte 2 — DER + Dicionário de Dados
**Entregue em:** 02/06/2026 · **Arquivos:** `parte2-DER.pdf` · `parte2-dicionario.pdf`

**Diagrama Entidade-Relacionamento** completo com:
- Notação MySQL Workbench
- Chaves primárias e estrangeiras identificadas
- Cardinalidades em todos os relacionamentos
- Layout profissional com legenda técnica

**Dicionário de Dados** documentando todas as tabelas do sistema:

| Tabela | Descrição |
|---|---|
| `ong` | Cadastro das organizações |
| `projeto` | Projetos sociais vinculados às ONGs |
| `beneficiario` | Pessoas atendidas pelos projetos |
| `voluntario` | Voluntários cadastrados |
| `doador` | Doadores (PF e PJ) |
| `doacao` | Registro de doações realizadas |
| `recurso` | Catálogo de recursos disponíveis |
| `projeto_beneficiario` | Vínculo N:N entre projetos e beneficiários |
| `voluntario_projeto` | Vínculo N:N entre voluntários e projetos |
| `projeto_recurso` | Alocação de recursos por projeto |

---

### Parte 3 — Implementação SQL Completa
**Entregue em:** 23/06/2026 · **Arquivo:** `parte3-ongconnect.sql`

Script SQL único e executável no MySQL 8.0 contendo:
- `CREATE DATABASE` + `USE` + schema completo normalizado (3NF)
- 10 tabelas com chaves estrangeiras, constraints `UNIQUE` e `CHECK`
- Índices para relatórios de impacto social
- Triggers para rastreamento automático de doações (`log_doacao`)
- 5 views para dashboards gerenciais
- Mínimo de 50 registros de dados de teste realistas
- 15 consultas SQL complexas para relatórios sociais

#### Views disponíveis
| View | Descrição |
|---|---|
| `vw_recursos_por_projeto` | Total de recursos utilizados por projeto |
| `vw_arrecadacao_por_projeto` | Soma de doações recebidas por projeto |
| `vw_voluntarios_por_projeto` | Voluntários ativos e suas funções |
| `vw_doadores_fieis` | Doadores com mais de uma doação registrada |
| `vw_impacto_por_projeto` | Consolidação de métricas de impacto social |

#### Como executar

```bash
mysql -u root -p < parte3-ongconnect.sql
```

Ou importe diretamente pelo MySQL Workbench:
`File → Open SQL Script → parte3-ongconnect.sql → Execute`

---

## 🗂️ Critérios Atendidos

### Parte 1 — MER
- [x] 6+ entidades do contexto ONG
- [x] Atributos sociais completos com tipos e restrições
- [x] Relacionamentos com cardinalidades 100% especificadas

### Parte 2 — DER + Dicionário
- [x] Notação correta (MySQL Workbench)
- [x] Profissionalismo visual com legenda técnica
- [x] Dicionário de dados contextualizado ao terceiro setor

### Parte 3 — SQL 
- [x] Schema normalizado (3NF) para terceiro setor
- [x] Integridade referencial completa
- [x] 15 consultas de impacto social
- [x] 50+ registros de dados de teste realistas

---

## 👥 Equipe

| Função | Responsável | Entregas |
|---|---|---|
| Líder Técnico | — | DER + Script SQL |
| Analista MER | — | Parte 1 completa |
| Arquiteto BD | — | Schema otimizado |
| Tester / QA | — | Dados de teste + relatórios |

---

## 🛠️ Tecnologias

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Workbench](https://img.shields.io/badge/MySQL_Workbench-Modelagem-orange)
![Git](https://img.shields.io/badge/Git-Versionamento-red)
