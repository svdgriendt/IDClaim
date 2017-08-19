CREATE TABLE [dbo].[IDClaim]
(
  [ID] BIGINT NOT NULL IDENTITY(1,1),
  [Database] SYSNAME NOT NULL,
  [Schema] SYSNAME NOT NULL,
  [Table] SYSNAME NOT NULL,
  [StartFreeRange] BIGINT NOT NULL,
  [DefaultClaimSize] INT NOT NULL,

  CONSTRAINT [pkIDClaim] PRIMARY KEY NONCLUSTERED ([ID]),
  CONSTRAINT [ucIDClaim] UNIQUE CLUSTERED ([Database], [Schema], [Table])
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description',  @value = N'Primary ID',  @level0type = N'SCHEMA',  @level0name = N'dbo',  @level1type = N'TABLE',  @level1name = N'IDClaim',  @level2type = N'COLUMN',  @level2name = N'ID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',  @value = N'Name of the database for the claims',  @level0type = N'SCHEMA',  @level0name = N'dbo',  @level1type = N'TABLE',  @level1name = N'IDClaim',  @level2type = N'COLUMN',  @level2name = N'Database'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',  @value = N'Name of the schema for the claims',  @level0type = N'SCHEMA',  @level0name = N'dbo',  @level1type = N'TABLE',  @level1name = N'IDClaim',  @level2type = N'COLUMN',  @level2name = N'Schema'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',  @value = N'Name of the table for the claims',  @level0type = N'SCHEMA',  @level0name = N'dbo',  @level1type = N'TABLE',  @level1name = N'IDClaim',  @level2type = N'COLUMN',  @level2name = N'Table'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',  @value = N'First available not claimed ID',  @level0type = N'SCHEMA',  @level0name = N'dbo',  @level1type = N'TABLE',  @level1name = N'IDClaim',  @level2type = N'COLUMN',  @level2name = N'StartFreeRange'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',  @value = N'Default size of the range of IDs to claim at once',  @level0type = N'SCHEMA',  @level0name = N'dbo',  @level1type = N'TABLE',  @level1name = N'IDClaim',  @level2type = N'COLUMN',  @level2name = N'DefaultClaimSize'
GO