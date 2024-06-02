# Overview

The Contracts Management System is a Python-based framework designed to load, manage, and deploy data contracts from a configuration file. It defines several classes to handle configurations, columns, contracts, and formats for generating SQL scripts and managing data marts.

## Table of Contents

1. [Summary]()
2. [Contracts](docs/contracts.md)     
3. [Contract Class](#contract-class)  
4. [Contracts Class](#contracts-class)    
5. [Formats Class](#formats-class)    
6. [Utilities](#utilities)    
7. [Usage](#usage)    
2. [Contracts](core/contracts.md)     
3. [Contract Class](#contract-class)  
4. [Contracts Class](#contracts-class)    
5. [Formats Class](#formats-class)    
6. [Utilities](#utilities)    
7. [Usage](#usage)


Business Intelligence Acelleration Framework 
by Chi Adiukwu



## User Actions
This framework is being developed to be highly automated and the below actions should be the only manual actions by the user.
1. Populate excel file.
2. Populate config.yml
3. Add enrich logic

## Automated Actions
1. Contract generation
2. Contracts Loaded
3. SQL generated     
3.1. Database SQL     
3.2. Synapse SQL     
3.3. Databricks SQL      
