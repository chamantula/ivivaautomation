USE [asp]
GO
/****** Object:  Table [dbo].[AccountDomainMap]    Script Date: 10/21/2020 5:34:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountDomainMap](
	[Key] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [varchar](255) NULL,
	[Domain] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AccountDomainMap] ON 

INSERT [dbo].[AccountDomainMap] ([Key], [AccountID], [Domain]) VALUES (1, N'eutech', N'localhost')
INSERT [dbo].[AccountDomainMap] ([Key], [AccountID], [Domain]) VALUES (2, N'eutech', N'192.168.29.154')
INSERT [dbo].[AccountDomainMap] ([Key], [AccountID], [Domain]) VALUES (3, N'eutech', N'eutech.v4tst.com')
SET IDENTITY_INSERT [dbo].[AccountDomainMap] OFF
GO
