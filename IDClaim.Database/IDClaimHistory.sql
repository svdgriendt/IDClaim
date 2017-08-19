CREATE TABLE [dbo].[IDClaimHistory]
(
  [ID] BIGINT NOT NULL,
  [IssueDate] DATETIME2(2) NOT NULL,
  [RangeStart] BIGINT NOT NULL,
  [RangeEnd] BIGINT NOT NULL,
  [Requestor] VARCHAR(64) NOT NULL,

  CONSTRAINT [pkIDClaimHistory] PRIMARY KEY CLUSTERED ([ID], [IssueDate] DESC),
  CONSTRAINT [fkIDClaimHistory_IDClaim] FOREIGN KEY ([ID]) REFERENCES [dbo].[IDClaim]([ID])
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referenced ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IDClaimHistory', @level2type = N'COLUMN', @level2name = N'ID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Date of issue of the range', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IDClaimHistory', @level2type = N'COLUMN', @level2name = N'IssueDate'
GO
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Inclusive starting ID of the range', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IDClaimHistory', @level2type = N'COLUMN', @level2name = N'RangeStart'
GO
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Inclusive ending ID of the range', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IDClaimHistory', @level2type = N'COLUMN', @level2name = N'RangeEnd'
GO
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Name of the requesting module', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IDClaimHistory', @level2type = N'COLUMN', @level2name = N'Requestor'
GO