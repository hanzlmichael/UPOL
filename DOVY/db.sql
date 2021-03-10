CREATE TABLE [dbo].[auto] (
    [spz]    VARCHAR (10) NOT NULL,
    [znacka] VARCHAR (50) NOT NULL,
    [barva]  VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([spz] ASC),
    UNIQUE NONCLUSTERED ([spz] ASC)
);

CREATE TABLE [dbo].[ridic] (
    [Id]       INT          IDENTITY (1, 1) NOT NULL,
    [jmeno]    VARCHAR (50) NOT NULL,
    [prijmeni] VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[zakaznik] (
    [Id]       INT          IDENTITY (1, 1) NOT NULL,
    [jmeno]    VARCHAR (50) NOT NULL,
    [prijmeni] VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[zakazka] (
    [Id]               INT          IDENTITY (1, 1) NOT NULL,
    [cislo_objednavky] VARCHAR (50) NOT NULL,
    [zakaznikID]       INT          NOT NULL,
    [ridicID]          INT          NOT NULL,
    [datum]            DATE         NOT NULL,
    [stav]             VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    FOREIGN KEY ([zakaznikID]) REFERENCES [dbo].[zakaznik] ([Id]),
    FOREIGN KEY ([ridicID]) REFERENCES [dbo].[ridic] ([Id])
);

CREATE TABLE [dbo].[smena] (
    [Id]      INT          IDENTITY (1, 1) NOT NULL,
    [ridicID] INT          NOT NULL,
    [autoSPZ] VARCHAR (10) NOT NULL,
    [datum]   DATE         NOT NULL,
    [km]      INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    FOREIGN KEY ([ridicID]) REFERENCES [dbo].[ridic] ([Id]),
    FOREIGN KEY ([autoSPZ]) REFERENCES [dbo].[auto] ([spz])
);

