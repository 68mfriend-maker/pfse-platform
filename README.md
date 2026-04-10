# PFSE Platform (Partner Fit & Strategy Engine)

PFSE is a graph-powered decision engine that:
- Determines partner strategy
- Maps software ecosystem adjacency
- Recommends System Integrators (SIs)

## Architecture

GitHub (CSV) → Neo4j → Node API → UI

## Setup

1. Upload CSVs to GitHub
2. Run cypher/load_all.cypher in Neo4j
3. Start API:

cd api
npm install
node server.js

## API Endpoints

POST /pfse
POST /strategy
POST /partners
POST /load-csv
