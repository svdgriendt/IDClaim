CREATE PROCEDURE [dbo].[RequestClaim]
  @Database SYSNAME NOT NULL,
  @Schema SYSNAME NOT NULL,
  @Table SYSNAME NOT NULL,
  @ClaimSize INT NULL,
  @Requestor VARCHAR(64) NOT NULL
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
  DECLARE @ID BIGINT;
  DECLARE @StartFreeRange BIGINT;
  DECLARE @DefaultClaimSize INT;
  DECLARE @UpdatedRecords [dbo].[NewStartFreeRangeType];

  -- Get the current record
  SELECT @ID = ID, @StartFreeRange = StartFreeRange, @DefaultClaimSize = DefaultClaimSize
  FROM [dbo].[IDClaim]
  WHERE [Database] = @Database AND [Schema] = @Schema AND [Table] = @Table;

  -- When there's no current record
  IF @ID IS NULL
    THROW 51000, 'The record does not exist.', 1;

  -- Set the claim size with the default one if not provided
  IF @ClaimSize IS NULL
    SET @ClaimSize = @DefaultClaimSize;

  -- Try up to 10 times to get a claim
  DECLARE @Exists BIT;
  DECLARE @Index TINYINT = 0;
  WHILE @Index < 10
  BEGIN
    -- Update the table (note that we include the range we want to claim)
    UPDATE [dbo].[IDClaim]
    SET [StartFreeRange] = @StartFreeRange + @ClaimSize
    OUTPUT [inserted].[StartFreeRange] INTO @UpdatedRecords
    WHERE [ID] = @ID AND [StartFreeRange] = @StartFreeRange;

    -- Only when a row has been updated, create a history item and return the claim

    SET @Exists = (SELECT TOP 1 1 FROM @UpdatedRecords)
    IF @Exists = 1
    BEGIN
      INSERT INTO [dbo].[IDClaimHistory] VALUES (@ID, SYSDATETIME(), @StartFreeRange, @StartFreeRange + @ClaimSize - 1, @Requestor);
      SELECT @StartFreeRange [StartRange], @StartFreeRange + @ClaimSize - 1 [EndRange];
      RETURN;
    END

    -- Retry by updating the range we want to claim
    SELECT @StartFreeRange = StartFreeRange
    FROM [dbo].[IDClaim]
    WHERE [ID] = @ID;

    SET @Index = @Index + 1;
  END;

  -- Reached the end of tries
  THROW 51000, 'Could not get the claim.', 1;
END
