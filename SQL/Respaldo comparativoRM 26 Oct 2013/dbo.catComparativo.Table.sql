USE [ComparativoRM]
GO
/****** Object:  Table [dbo].[catComparativo]    Script Date: 10/26/2013 16:19:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[catComparativo](
	[ClaveMovimiento] [char](1) NULL,
	[TipoMovimiento] [char](1) NULL,
	[Area] [varchar](15) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'3', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'4', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'5', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'6', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'7', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'8', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'A', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'B', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'C', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'A', N'D', N'TiempoAire')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'M', N'1', N'Muebles')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'M', N'2', N'Muebles')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'M', N'5', N'Devoluciones')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'M', N'5', N'Muebles')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'M', N'6', N'Devoluciones')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'M', N'6', N'Muebles')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'M', N'9', N'Devoluciones')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'R', N'1', N'Ropa')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'R', N'4', N'Ropa')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'R', N'5', N'Ropa')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'R', N'6', N'Ropa')
INSERT [dbo].[catComparativo] ([ClaveMovimiento], [TipoMovimiento], [Area]) VALUES (N'R', N'8', N'Ropa')
