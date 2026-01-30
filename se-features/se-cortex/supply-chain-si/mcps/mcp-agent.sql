
USE ROLE SYSADMIN;
USE DATABASE SNOWFLAKE_INTELLIGENCE;
USE SCHEMA SNOWFLAKE_INTELLIGENCE.MCP;

CREATE OR REPLACE MCP SERVER SUPPLY_CHAIN_MCP
  FROM SPECIFICATION $$
    tools:
      - title: "SUPPLYCHAIN"
        name: "SUPPLY_CHAIN_AGENT"
        type: "CORTEX_AGENT_RUN"
        identifier: "SNOWFLAKE_INTELLIGENCE.AGENTS.SUPPLY_CHAIN_AGENT"
        description: "Agent that gives the ability to search the supply chain data AND documentation and answer questions about the supply chain."
  $$

SHOW MCP SERVERS;
DESCRIBE MCP SERVER SUPPLY_CHAIN_MCP;

-- Test the MCP server

-- curl -X POST \
--   "https://<ACCOUNT_NAME>.snowflakecomputing.com/api/v2/databases/snowflake_intelligence/schemas/agents/mcp-servers/supply_chain_mcp" \
--   -H "Authorization: Bearer <PAT_TOKEN>" \
--   -H "Content-Type: application/json" \
--   -d '{"jsonrpc": "2.0", "id": 1, "method": "tools/list"}'
