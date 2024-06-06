# Overview

The Contracts Management System is a Python-based framework designed to load, manage, and deploy data contracts from a configuration file. It defines several classes to handle configurations, columns, contracts, and formats for generating SQL scripts and managing data marts.

This framework is being developed to be highly automated and the below actions should be the only manual actions by the user.

### Prerequisites and Tasks
1. Populate excel file.
2. Populate config.yml
3. Add enrich logic


## Table of Contents

1. [Summary]()
2. [To Do]()
3. [Contracts](docs/contracts.md)     
4. [Contract Class](#contract-class)  
5. [Contracts Class](#contracts-class)    
6. [Formats Class](#formats-class)    
7. [Utilities](#utilities)    
2. [Usage](#usage)    
3. [Contracts](core/contracts.md)     
4. [Contract Class](#contract-class)  
5. [Contracts Class](#contracts-class)    
6. [Formats Class](#formats-class)    
7. [Utilities](#utilities)    
8. [Usage](#usage)



## Features

|Activity |Resource|Status|Notes|
|---|---|---|---|
|Deploy Infrastructure      |Control Database           |Completed      || 
|Deploy Code                |Control Database           |Completed      || 
|Deploy Infrastructure      |Warehouse Database         |Completed      ||
|Generate Code              |Staging Contracts          |Completed      ||
|Generate Code              |Warehouse Database         |Completed      |Auto Gen "Stage" schema and deploy|
|Deploy Code                |Warehouse Database         |Completed      || 
|Deploy Infrastructure      |Azure Data Factory         |Completed      || 
|Build Pipelines            |Azure Data Factory         |In progress    || 
|Deploy Code                |Azure Data Factory         |               || 
|Generate Code              |Control Database           |               || 
|Generate Code              |Synapse                    |               ||
|Deploy Infrastructure      |Synapse                    |               ||
|Deploy Code                |Synapse                    |               || 
|Build Pipelines            |Synapse Pipelines          |               || 
|Deploy Infrastructure      |Synapse Pipelines          |               || 
|Deploy Code                |Synapse Pipelines          |               || 
|Deploy Infrastructure      |Databricks                 |               ||
|Generate Code              |Databricks                 |               || 
|Deploy Code                |Databricks                 |               || 
|Generate Code              |Power BI Model             |               || 
|Deploy Code                |Power BI Model             |               || 
|Generate Code              |Analysis Services Model    |               || 
|Deploy Code                |Azure Synapse pipelines    |               || 
|