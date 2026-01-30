# Supply Chain Assistant with Snowflake Intelligence

## Solution Overview

Modern supply chain operations face a critical challenge: efficiently managing raw material inventory across multiple manufacturing facilities. Operations managers must constantly balance inventory levels, deciding whether to transfer materials between plants with excess and shortage, or purchase new materials from suppliers. Making these decisions manually is time-consuming, error-prone, and often results in suboptimal cost outcomes.

This quickstart demonstrates how to build an intelligent supply chain assistant using Snowflake Intelligence and Cortex AI capabilities. By combining natural language querying with semantic search over both structured and unstructured data, you'll create a complete solution that helps operations managers make data-driven decisions about inventory management.

Here is a summary of what you will be able to learn by following this quickstart:

* **Setup Environment**: Create a comprehensive supply chain database with tables for manufacturing plants, inventory, suppliers, customers, orders, shipments, and weather data
* **Cortex Analyst**: Build semantic models for supply chain operations and weather forecasts that enable natural language text-to-SQL queries
* **Cortex Search**: Index unstructured supply chain documentation for intelligent retrieval using RAG (Retrieval Augmented Generation)
* **Custom Tools**: Integrate web search, web scraping, HTML generation, and email capabilities into your AI agent
* **Snowflake Intelligence**: Create a comprehensive AI agent with 7 tools that intelligently routes user questions and combines multiple data sources
* **Advanced Analytics**: Perform complex multi-domain analysis including supply chain optimization, weather impact analysis, and external research

## The Problem

![Alt text](/images/problem.png "The Problem")

Supply chain operations managers face daily challenges managing raw material inventory across manufacturing facilities:

* **Inventory Imbalances**: Some plants have excess raw materials while others face shortages, creating inefficiency
* **Complex Decision Making**: Determining whether to transfer materials between plants or purchase from suppliers requires analyzing multiple factors including material costs, transport costs, lead times, and safety stock levels
* **Manual Analysis**: Traditional approaches require running multiple reports, spreadsheet analysis, and manual cost comparisons
* **Time Sensitivity**: Inventory decisions need to be made quickly to avoid production delays or excess carrying costs

## The Solution

![Alt text](/images/solution.png "The Solution")

This solution leverages Snowflake Intelligence and Cortex AI capabilities to create an intelligent assistant that:

1. **Answers Ad-Hoc Questions**: Operations managers can ask natural language questions about inventory levels, orders, shipments, and supplier information - the agent automatically converts questions to SQL and executes them
2. **Provides Contextual Information**: The assistant can search and retrieve relevant information from supply chain documentation using semantic search
3. **Intelligent Routing**: Automatically determines whether to query structured data (via Cortex Analyst) or search documents (via Cortex Search) based on the nature of the question
4. **Complex Analysis**: Handles sophisticated multi-table queries like identifying plants with low inventory alongside plants with excess inventory of the same materials, and comparing costs between suppliers and inter-plant transfers
5. **No-Code Agent Creation**: Build and deploy the entire solution using Snowflake Intelligence's visual interface without writing application code

## What is Snowflake Cortex?

Snowflake Cortex provides fully managed Generative AI capabilities that run securely within your Snowflake environment and governance boundary. Key features include:

**Cortex Analyst** - Enables business users to ask questions about structured data in natural language. It uses a semantic model to understand your data and generates accurate SQL queries automatically.

**Cortex Search** - Provides easy-to-use semantic search over unstructured data. It handles document chunking, embedding generation, and retrieval, making it simple to implement RAG (Retrieval Augmented Generation) patterns.

**Cortex Agents** - Orchestrates multiple AI capabilities (like Analyst and Search) to intelligently route user queries to the appropriate service and synthesize responses.

Learn more about [Snowflake Cortex](https://www.snowflake.com/en/product/features/cortex/).

## What is Snowflake Intelligence?

Snowflake Intelligence is a unified experience for building and deploying AI agents within Snowflake. It provides:

* **No-Code Agent Builder**: Create agents that combine multiple tools (Cortex Analyst, Cortex Search, Custom Tools) without writing code
* **Integrated Tools**: Easily connect your semantic models and search services as agent capabilities
* **Conversational Interface**: Interact with your agent through a chat interface within Snowsight
* **Enterprise Ready**: Built on Snowflake's security and governance foundation

Learn more about [Snowflake Intelligence](https://docs.snowflake.com/en/user-guide/snowflake-cortex/snowflake-intelligence).

## What You Will Learn

* How to model a multi-tier supply chain in Snowflake with proper relationships
* How to create semantic models for Cortex Analyst with dimensions, measures, and verified queries
* How to set up Cortex Search services on unstructured documents
* How to build comprehensive AI agents using Snowflake Intelligence
* How to combine multiple semantic models in a single agent for cross-domain analysis
* How to integrate custom tools (functions and stored procedures) into your agent
* How to enable web search and scraping capabilities within your AI assistant
* How to write effective tool descriptions and semantic models for accurate AI responses
* How to handle complex analytics questions that span multiple data sources

## What You Will Build

* A comprehensive supply chain database with 11 tables and realistic sample data
* Two semantic models: one for supply chain data and one for weather forecasts
* A Cortex Search service indexed on supply chain documentation
* A Snowflake Intelligence agent with 7 tools:
  * 2 Cortex Analyst tools (supply chain and weather data)
  * 1 Cortex Search tool (documentation)
  * 4 Custom tools (web search, web scraping, HTML newsletter generation, email sending)
* Complex verified queries for inventory analysis, cost comparison, and rebalancing opportunities
* A production-ready AI assistant that combines structured data, unstructured data, and external web sources

## Prerequisites

* A Snowflake account with Cortex features enabled. If you do not have a Snowflake account, you can [register for a free trial](https://signup.snowflake.com/).
* A Snowflake account login with ACCOUNTADMIN role OR a role that has the ability to create databases, schemas, tables, stages, and Cortex Search services.
* Cortex Analyst, Cortex Search, and Snowflake Intelligence must be available in your Snowflake region.

---

## Step 1 - Setup Database and Load Data

1. Open a new worksheet in Snowsight
2. Import the **scripts/setup.sql** file.
3. Run All.

This script will create:

* Database: `SUPPLY_CHAIN_ASSISTANT_DB` with schemas `ENTITIES` and `WEATHER`
* Warehouse: `SUPPLY_CHAIN_ASSISTANT_WH`
* All supply chain tables (suppliers, plants, inventory, orders, etc.)
* Internal stages for PDFs and semantic models
* Sample data loaded via INSERT statements

## Step 2 - Upload Documents and Semantic Models

Within the first step, all objects have been created in SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES database/schema.
We created two internal stages, and will upload files to them now.

1. Navigate to the **Database Explorer** from the left side menu under **Horizon Catalog**.
2. Navigate to the SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES database/schema, and then to **Stages**.
3. In the **SUPPLY_CHAIN_ASSISTANT_PDF_STAGE** stage, upload the **pdfs/Supply Chain Network Overview.pdf** file using the **+ Files** button on the top right
4. In the **SEMANTIC_MODELS_STAGE** stage, upload both semantic model files:
   * **scripts/semantic_models/SUPPLY_CHAIN_ASSISTANT_MODEL.yaml**
   * **scripts/semantic_models/WEATHER_FORECAST.yaml**

## Step 3 - Cortex Search Service Creation

You have two options to create the Cortex Search service:

### Option A: Using SQL Script

1. Open a new worksheet in Snowsight
2. Import the **scripts/configure_search_services.sql** file
3. Run All

This script will:

* Parse PDFs using Cortex PARSE_DOCUMENT
* Chunk the content into searchable segments
* Create the `PARSED_PDFS` table with presigned URLs
* Create the `SUPPLY_CHAIN_INFO` Cortex Search service
* Set up a task to refresh presigned URLs daily

### Option B: Manual Creation via Snowsight UI

If you prefer to create the search service manually:

#### Step 3.1: Prepare the Data (SQL Required)

Even with the UI approach, you'll need to run some SQL to parse and prepare the documents. Open a new worksheet and run:

```sql
USE SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES;
USE WAREHOUSE SUPPLY_CHAIN_ASSISTANT_WH;

-- Scale up warehouse for PDF parsing
ALTER WAREHOUSE SUPPLY_CHAIN_ASSISTANT_WH SET WAREHOUSE_SIZE = 'X-LARGE';

-- Parse PDFs
CREATE OR REPLACE TABLE PARSE_PDFS AS 
SELECT RELATIVE_PATH, 
       SNOWFLAKE.CORTEX.PARSE_DOCUMENT(@SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES.SUPPLY_CHAIN_ASSISTANT_PDF_STAGE, 
                                        RELATIVE_PATH, 
                                        {'mode':'LAYOUT'}) AS DATA
FROM DIRECTORY(@SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES.SUPPLY_CHAIN_ASSISTANT_PDF_STAGE);

-- Chunk and prepare content
CREATE OR REPLACE TABLE PARSED_PDFS AS (
    WITH TMP_PARSED AS (
        SELECT RELATIVE_PATH,
               SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(TO_VARIANT(DATA):content, 'MARKDOWN', 1800, 300) AS CHUNKS
        FROM PARSE_PDFS 
        WHERE TO_VARIANT(DATA):content IS NOT NULL
    )
    SELECT TO_VARCHAR(C.value) AS PAGE_CONTENT,
           REGEXP_REPLACE(RELATIVE_PATH, '\\.pdf$', '') AS TITLE,
           RELATIVE_PATH,
           GET_PRESIGNED_URL(@SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES.SUPPLY_CHAIN_ASSISTANT_PDF_STAGE, RELATIVE_PATH, 604800) AS PAGE_URL
    FROM TMP_PARSED P, LATERAL FLATTEN(INPUT => P.CHUNKS) C
);

-- Scale warehouse back down
ALTER WAREHOUSE SUPPLY_CHAIN_ASSISTANT_WH SET WAREHOUSE_SIZE = 'SMALL';
```

#### Step 3.2: Create Search Service via UI

1. In Snowsight, navigate to **AI & ML** > **Cortex Search** in the left navigation
2. Click **+ Search Service** button
3. Configure the search service:
   * **Name:** `SUPPLY_CHAIN_INFO`
   * **Database:** `SUPPLY_CHAIN_ASSISTANT_DB`
   * **Schema:** `ENTITIES`
   * **Warehouse:** `SUPPLY_CHAIN_ASSISTANT_WH`
   * **Source Table:** `PARSED_PDFS`
   * **Search Column:** Select `PAGE_CONTENT`
   * **Target Lag:** `1 hour`
4. Click **Create Search Service**

## Step 4 - Create Your Snowflake Intelligence Agent

Now that you have your semantic models and search service created, you can combine them into an intelligent agent using Snowflake Intelligence.

1. Click on **Agents** within the AI & ML section on the left-hand navigation bar in Snowsight
2. Click **Create Agent** and name it **Supply_Chain_Agent**
3. Once created, click **Edit**, then navigate to **Tools** on the left

### Add First Cortex Analyst Tool - Supply Chain Data

1. Click **Add Tool** and select **Cortex Analyst**
2. Name it **SUPPLY_CHAIN_ASSISTANT_MODEL**
3. Click **Semantic Model File** and navigate to:
   * Database: `SUPPLY_CHAIN_ASSISTANT_DB`
   * Schema: `ENTITIES`
   * Stage: `SEMANTIC_MODELS_STAGE`
   * File: `SUPPLY_CHAIN_ASSISTANT_MODEL.yaml`
4. Select warehouse: `SUPPLY_CHAIN_ASSISTANT_WH`
5. Add tool description: *"Tool for analyzing supply chain data."*

### Add Second Cortex Analyst Tool - Weather Data

1. Click **Add Tool** and select **Cortex Analyst**
2. Name it **WEATHER_FORECAST**
3. Click **Semantic Model File** and navigate to:
   * Database: `SUPPLY_CHAIN_ASSISTANT_DB`
   * Schema: `WEATHER`
   * Stage: `SEMANTIC_MODELS_STAGE`
   * File: `WEATHER_FORECAST.yaml`
4. Select warehouse: `SUPPLY_CHAIN_ASSISTANT_WH`
5. Add tool description: *"Tool for analyzing weather data."*

### Add Cortex Search Tool

1. Click **Add Tool** and select **Cortex Search**
2. Name it **SUPPLY_CHAIN_INFO**
3. Add tool description: *"Tool for searching supply chain unstructured data."*
4. Select the search service: `SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES.SUPPLY_CHAIN_INFO`
5. Set **PAGE_URL** as the ID column and **TITLE** as the Title column

### Add Custom Tools

For each of the following custom tools, click **Add Tool** and select **Custom Tool**, then configure:

#### 1. CREATE_HTML_NEWSLETTER

* Type: Stored Procedure
* Schema: `SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES`
* Name: `CREATE_HTML_NEWSLETTER_SP`
* Description: *"Create HTML newsletter from responses."*

#### 2. WEB_SEARCH

* Type: Function
* Schema: `SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES`
* Name: `WEB_SEARCH`
* Description: *"Search the web using DuckDuckGo."*

#### 3. WEB_SCRAPE

* Type: Function
* Schema: `SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES`
* Name: `WEB_SCRAPE`
* Description: *"Web scraping and content extraction."*

#### 4. Send_Emails (Optional - requires a verified email address)

* Type: Stored Procedure
* Schema: `SUPPLY_CHAIN_ASSISTANT_DB.ENTITIES`
* Name: `SEND_MAIL`
* Description: *"Send emails to recipients with HTML formatted content."*

### Save and Test Your Agent

1. Click **Save** to save your agent configuration
2. Start testing the agent directly on the right hand pane **or** Navigate to **Snowflake Intelligence** in the left navigation AI & ML menu
3. Select your agent from the dropdown
4. Start asking questions!

## Step 5 - Try These Example Questions

Start with simple questions and build up to more complex analysis. Notice how the agent automatically determines which tool to use based on your question!

**Supply Chain Data Questions (Cortex Analyst - Supply Chain Model):**

* "How many orders did we receive in the last month?"
* "Which manufacturing plants have low inventory for which raw materials?"
* "Who are our top 5 customers by order value?"
* "What's the total quantity of finished goods in our manufacturing plants?"
* "Which manufacturing plants have low inventory of raw materials AND which plants have excess inventory of those same materials?"
* "For plants with low inventory of a raw material, compare the cost of replenishing from a supplier vs transferring from another plant with excess inventory"

**Weather Data Questions (Cortex Analyst - Weather Model):**

* "What's the weather forecast for Seattle?"
* "Which cities have the highest precipitation probability?"
* "Show me the temperature forecast for Phoenix"
* "What are the wind conditions in Chicago?"

**Documentation Questions (Cortex Search):**

* "Explain how shipment tracking works in our business"
* "What are our business lines?"
* "How does our supply chain network operate?"

**Web Research Questions (Custom Tools - Web Search & Web Scrape):**

* "Search the web for recent supply chain disruptions"
* "What are the latest trends in supply chain management?"

**Email and Newsletter Creation (Custom Tools):**

* "Create an HTML newsletter summarizing our top customers this month"
* "Draft an email about our current inventory status" (Note: sending requires email integration)

**Cross-Tool Complex Questions:**

* "What's the weather forecast for cities where our manufacturing plants are located?"
* "Compare inventory levels at plants with upcoming severe weather conditions"

![Alt text](/images/Agent.gif "Snowflake Intelligence")

## Next Steps

Congratulations! You've built a comprehensive Supply Chain Assistant powered by Snowflake Intelligence that combines:

* **Dual Analytics:** Query both supply chain operations and weather data
* **Semantic Search:** Access unstructured supply chain documentation
* **Web Integration:** Search and scrape external information
* **Communication:** Generate HTML newsletters and send emails (with proper integration)

You can extend this solution further by:

* Adding more semantic models for other business domains
* Integrating additional data sources
* Creating custom tools for specific business processes
* Building Streamlit applications that interact with your agent
