-- SILVER
-- execute [enriched].[sp_fact_Order]
-- execute [enriched].[sp_fact_Purchase]
-- execute [enriched].[sp_fact_Sale]
-- execute [enriched].[sp_fact_Transaction]
-- Gold Fact Transform
-- execute [enriched].[sp_fact_Order]
-- execute [enriched].[sp_fact_Purchase]
-- execute [enriched].[sp_fact_Sale]
-- execute [enriched].[sp_fact_Transaction]
-- select CONCAT('Drop table ',TABLE_SCHEMA,'.[',TABLE_NAME,'];') as q from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'curated'
/*
Drop table curated.[dim_Supplier];
Drop table curated.[fact_Transaction];
Drop table curated.[dim_Customer];
Drop table curated.[dim_City];
Drop table curated.[fact_Order];
Drop table curated.[fact_Movement];
Drop table curated.[dim_Employee];
Drop table curated.[dim_PaymentMethod];
Drop table curated.[dim_StockItem];
Drop table curated.[dim_TransactionType];
Drop table curated.[fact_StockHolding];
Drop table curated.[dim_Date];
Drop table curated.[fact_Sale];
Drop table curated.[fact_Purchase];
*/

execute [enriched].[sp_dim_City]
GO
execute [enriched].[sp_dim_Customer]
GO
execute [enriched].[sp_dim_Date]
GO
execute [enriched].[sp_dim_Employee]
GO
execute [enriched].[sp_dim_PaymentMethod]
GO
execute [enriched].[sp_dim_StockItem]
GO
execute [enriched].[sp_dim_Supplier]
GO
execute [enriched].[sp_dim_TransactionType]
GO
execute [curated].[sp_dim_City]
GO
execute [curated].[sp_dim_Customer]
GO
execute [curated].[sp_dim_Date]
GO
execute [curated].[sp_dim_Employee]
GO
execute [curated].[sp_dim_PaymentMethod]
GO
execute [curated].[sp_dim_StockItem]
GO
execute [curated].[sp_dim_Supplier]
GO
execute [curated].[sp_dim_TransactionType]
GO
execute [enriched].[sp_fact_Movement]
GO
execute [enriched].[sp_fact_StockHolding]
GO
execute [curated].[sp_fact_Movement]
GO
execute [curated].[sp_fact_StockHolding]