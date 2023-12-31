USE [BD_CRUD]
GO
/****** Object:  Table [dbo].[TB_CATEGORIAS]    Script Date: 1/7/2023 17:48:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_CATEGORIAS](
	[codigo_ca] [int] IDENTITY(1,1) NOT NULL,
	[descripcion_ca] [varchar](50) NULL,
	[activo] [bit] NULL,
 CONSTRAINT [PK_TB_CATEGORIAS] PRIMARY KEY CLUSTERED 
(
	[codigo_ca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_MEDIDAS]    Script Date: 1/7/2023 17:48:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_MEDIDAS](
	[codigo_me] [int] IDENTITY(1,1) NOT NULL,
	[descripcion_me] [varchar](50) NULL,
	[activo] [bit] NULL,
 CONSTRAINT [PK_TB_MEDIDAS] PRIMARY KEY CLUSTERED 
(
	[codigo_me] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_PRODUCTOS]    Script Date: 1/7/2023 17:48:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_PRODUCTOS](
	[codigo_pr] [int] IDENTITY(1,1) NOT NULL,
	[descripcion_pr] [varchar](80) NULL,
	[marca_pr] [varchar](30) NULL,
	[codigo_me] [int] NULL,
	[codigo_ca] [int] NULL,
	[stock_actual] [decimal](18, 2) NULL,
	[fecha_crea] [datetime] NULL,
	[activo] [bit] NULL,
 CONSTRAINT [PK_TB_PRODUCTOS] PRIMARY KEY CLUSTERED 
(
	[codigo_pr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TB_PRODUCTOS]  WITH CHECK ADD  CONSTRAINT [FK_TB_PRODUCTOS_TB_CATEGORIAS] FOREIGN KEY([codigo_ca])
REFERENCES [dbo].[TB_CATEGORIAS] ([codigo_ca])
GO
ALTER TABLE [dbo].[TB_PRODUCTOS] CHECK CONSTRAINT [FK_TB_PRODUCTOS_TB_CATEGORIAS]
GO
ALTER TABLE [dbo].[TB_PRODUCTOS]  WITH CHECK ADD  CONSTRAINT [FK_TB_PRODUCTOS_TB_MEDIDAS] FOREIGN KEY([codigo_me])
REFERENCES [dbo].[TB_MEDIDAS] ([codigo_me])
GO
ALTER TABLE [dbo].[TB_PRODUCTOS] CHECK CONSTRAINT [FK_TB_PRODUCTOS_TB_MEDIDAS]
GO
/****** Object:  StoredProcedure [dbo].[ACTIVO_PR]    Script Date: 1/7/2023 17:48:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ACTIVO_PR]
@nCodigo_pr int,
@bEstado_activo bit
AS
	UPDATE TB_PRODUCTOS set activo = @bEstado_activo
						where codigo_pr = @nCodigo_pr
GO
/****** Object:  StoredProcedure [dbo].[USP_GUARDAR_PR]    Script Date: 1/7/2023 17:48:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[USP_GUARDAR_PR]  
@Opcion int = 1, -- 1 = Nuevo Registro / 2 = Actualizar Registro  
@nCodigo_pr int,  
@cDescripcion_pr varchar(80),  
@cMarca_pr varchar(30),  
@nCodigo_me int,  
@nCodigo_ca int,  
@nStock_actual decimal(18,2)  
AS  
 if @Opcion = 1 --Nuevo Registro  
  begin  
   INSERT INTO TB_PRODUCTOS(descripcion_pr,  
         marca_pr,  
         codigo_me,  
         codigo_ca,  
         stock_actual,  
         fecha_crea,  
         activo)  
       values(@cDescripcion_pr,  
           @cMarca_pr,  
           @nCodigo_me,  
              @nCodigo_ca,  
           @nStock_actual,  
           getdate(),  
           1);  
  end;  
 else --Actualizar Registro  
  begin  
   Update TB_PRODUCTOS set descripcion_pr = @cDescripcion_pr,  
         marca_pr = @cMarca_pr,  
         codigo_me = @nCodigo_me,  
         codigo_ca = @nCodigo_ca,  
         stock_actual = @nStock_actual  
        where codigo_pr = @nCodigo_pr;  
  end;  
GO
/****** Object:  StoredProcedure [dbo].[USP_LISTADO_CA]    Script Date: 1/7/2023 17:48:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_LISTADO_CA]  
AS  
 SELECT DESCRIPCION_CA,  
     CODIGO_CA  
 FROM TB_CATEGORIAS 
 WHERE ACTIVO = 1;
GO
/****** Object:  StoredProcedure [dbo].[USP_LISTADO_ME]    Script Date: 1/7/2023 17:48:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_LISTADO_ME]
AS
	SELECT DESCRIPCION_ME,
		   CODIGO_ME
	FROM TB_MEDIDAS
	WHERE ACTIVO = 1;
GO
/****** Object:  StoredProcedure [dbo].[USP_LISTADO_PR]    Script Date: 1/7/2023 17:48:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_LISTADO_PR]
@cTexto varchar(80)=''
AS
	SELECT a.codigo_pr,
		   a.descripcion_pr,
		   a.marca_pr,
		   b.descripcion_me,
		   c.descripcion_ca,
		   a.stock_actual,
		   a.codigo_me,
		   a.codigo_ca
	FROM TB_PRODUCTOS a 
	inner join TB_MEDIDAS b on a.codigo_me = b.codigo_me
	inner join TB_CATEGORIAS  c on a.codigo_ca = c.codigo_ca
	where a.activo = 1 and 
		 UPPER(trim( a.descripcion_pr) +trim(a.marca_pr)) like '%'+UPPER(trim(@cTexto))+'%'
		 order by a.codigo_pr;
GO
