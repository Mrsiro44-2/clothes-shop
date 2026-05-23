/* Mom & Baby — Quên mật khẩu (token reset qua email) */
USE MomAndBaby;
GO

IF OBJECT_ID(N'dbo.PasswordResetToken', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PasswordResetToken (
        ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        accountID   INT NOT NULL,
        tokenHash   NVARCHAR(128) NOT NULL,
        expiresAt   DATETIME2(3) NOT NULL,
        usedAt      DATETIME2(3) NULL,
        createdAt   DATETIME2(3) NOT NULL CONSTRAINT DF_PasswordResetToken_created DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_PasswordResetToken_Account FOREIGN KEY (accountID)
            REFERENCES dbo.[Account](ID) ON DELETE CASCADE
    );

    CREATE UNIQUE INDEX UX_PasswordResetToken_hash ON dbo.PasswordResetToken(tokenHash);
    CREATE INDEX IX_PasswordResetToken_account ON dbo.PasswordResetToken(accountID);
END
GO
