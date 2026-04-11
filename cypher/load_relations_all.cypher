// LOAD QUESTIONS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/decision/questions.csv' AS row
CREATE (:Question {id: row.id, text: row.text});

// LOAD ANSWERS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/decision/answers.csv' AS row
CREATE (:Answer {value: row.value});

// LOAD CONDITIONS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/decision/conditions.csv' AS row
CREATE (:Condition {id: row.id, name: row.name});

// LOAD STRATEGIES
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/decision/strategies.csv' AS row
CREATE (:Strategy {name: row.name});

// LOAD PARTNER TYPES
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/decision/partner_types.csv' AS row
CREATE (:PartnerType {name: row.name});

// ANSWER → CONDITION
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/decision/answer_triggers.csv' AS row
MATCH (a:Answer {value: row.answer})
MATCH (c:Condition {id: row.condition})
CREATE (a)-[:TRIGGERS {weight: toFloat(row.weight)}]->(c);

// CONDITION → STRATEGY
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/decision/condition_strategy.csv' AS row
MATCH (c:Condition {id: row.condition})
MATCH (s:Strategy {name: row.strategy})

FOREACH (_ IN CASE WHEN row.type = "SUPPORTS" THEN [1] ELSE [] END |
    CREATE (c)-[:SUPPORTS {weight: toFloat(row.weight)}]->(s)
)

FOREACH (_ IN CASE WHEN row.type = "OPPOSES" THEN [1] ELSE [] END |
    CREATE (c)-[:OPPOSES {weight: toFloat(row.weight)}]->(s)
);

// STRATEGY → PARTNER TYPE
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/decision/strategy_partner.csv' AS row
MATCH (s:Strategy {name: row.strategy})
MATCH (p:PartnerType {name: row.partner_type})
CREATE (s)-[:RECOMMENDS {weight: toFloat(row.weight)}]->(p);

// QUESTION → ANSWERS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/decision/question_answers.csv' AS row
MATCH (q:Question {id: row.question})
MATCH (a:Answer {value: row.answer})
CREATE (q)-[:HAS_ANSWER]->(a);
