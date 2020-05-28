CREATE TABLE [pii].[UserCreditCard] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [ProfileId]        INT            NOT NULL,
    [CreditCardType]   NVARCHAR (50)  NOT NULL,
    [CreditCardNumber] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_UserCreditCard] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserCreditCard_Profiles] FOREIGN KEY ([ProfileId]) REFERENCES [dbo].[Profiles] ([Id])
);

