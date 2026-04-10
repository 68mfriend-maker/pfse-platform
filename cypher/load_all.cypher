// -----------------------------
// LOAD CATEGORIES
// -----------------------------
LOAD CSV WITH HEADERS FROM 
'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/ontology/categories.csv' AS row
MERGE (c:Category {id: row.category_id})
SET c.name = row.name;

// -----------------------------
// LOAD SUBCATEGORIES
// -----------------------------
LOAD CSV WITH HEADERS FROM 
'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/ontology/subcategories.csv' AS row
MATCH (c:Category {id: row.category_id})
MERGE (sc:SubCategory {id: row.subcategory_id})
SET sc.name = row.name
MERGE (sc)-[:BELONGS_TO]->(c);

// -----------------------------
// LOAD VENDORS
// -----------------------------
LOAD CSV WITH HEADERS FROM 
'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/ontology/vendors.csv' AS row
MATCH (sc:SubCategory {id: row.subcategory_id})
MERGE (v:Vendor {id: row.vendor_id})
SET v.name = row.name
MERGE (v)-[:IN_CATEGORY]->(sc);

// -----------------------------
// LOAD ADJACENCY
// -----------------------------
LOAD CSV WITH HEADERS FROM 
'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/ontology/category_adjacency.csv' AS row
MATCH (c1:Category {id: row.from_category})
MATCH (c2:Category {id: row.to_category})
MERGE (c1)-[:ADJACENT_TO {distance: toInteger(row.distance)}]->(c2);

// -----------------------------
// LOAD SI
// -----------------------------
LOAD CSV WITH HEADERS FROM 
'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/si/si.csv' AS row
MERGE (si:SI {id: row.si_id})
SET si.name = row.name,
    si.size = row.size,
    si.region = row.region,
    si.employees = toInteger(row.employees);

// -----------------------------
// SI → VENDOR
// -----------------------------
LOAD CSV WITH HEADERS FROM 
'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/si/si_vendor_relationships.csv' AS row
MATCH (si:SI {id: row.si_id})
MATCH (v:Vendor {id: row.vendor_id})
MERGE (si)-[:DELIVERS]->(v);

// -----------------------------
// SI CAPABILITIES
// -----------------------------
LOAD CSV WITH HEADERS FROM 
'https://raw.githubusercontent.com/68mfriend-maker/pfse-platform/main/data/si/si_capabilities.csv' AS row
MERGE (c:Capability {name: row.capability})
MATCH (si:SI {id: row.si_id})
MERGE (si)-[:HAS_CAPABILITY]->(c);
