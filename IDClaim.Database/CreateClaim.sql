CREATE PROCEDURE [dbo].[CreateClaim]
  @Database SYSNAME NOT NULL,
  @Schema SYSNAME NOT NULL,
  @Table SYSNAME NOT NULL,
  @StartFreeRange BIGINT NOT NULL,
  @DefaultClaimSize INT NOT NULL
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
  DECLARE @Exists BIT = (SELECT TOP 1 1
                         FROM [dbo].[IDClaim]
                         WHERE [Database] = @Database AND [Schema] = @Schema AND [Table] = @Table)
  IF @Exists IS NULL
    INSERT INTO [dbo].[IDClaim] VALUES (@Database, @Schema, @Table, @StartFreeRange, @DefaultClaimSize);
END
