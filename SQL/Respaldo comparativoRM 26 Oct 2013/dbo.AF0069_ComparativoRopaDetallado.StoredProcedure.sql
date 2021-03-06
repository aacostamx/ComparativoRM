USE [ComparativoRM]
GO
/****** Object:  StoredProcedure [dbo].[AF0069_ComparativoRopaDetallado]    Script Date: 10/26/2013 16:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[AF0069_ComparativoRopaDetallado]
(@FechaInicio char(10),@FechaFin varchar(10), @ip varchar(30), @id varchar(30), @pass varchar(70), @BaseDatos varchar(30))
as
-- =============================================
-- Autor: Antonio Acosta Murillo
-- Fecha: 16 Octubre 2013
-- Descripción General: Genera comparativo de ventas ropa de carteras contra inventario de ropa del mes con IP's Dinamicas
-- =============================================
begin

-------------------------------------  VENTAS ROPA GENERAL-------------------------------------
declare @sentencia as varchar(8000)
declare @sentencia2 as varchar(8000)  
declare @ano as char(4)
declare @hora as nvarchar(9)declare @opendatasource as nvarchar(100)
set @ano = (select year(fechacorte) from controltiendas.dbo.ctlmaestrafechas)
set @hora =  ((select CONVERT(nvarchar(40),getdate(),108)))
set @opendatasource = 'data source='

--Se crea la tabla "Bitacora" para almacenar la hora y la descripción de cada instrucción del procedimiento
if exists (select * from sysobjects where name = 'BitacoraCOMPARATIVOR') drop table BitacoraCOMPARATIVOR
create table BitacoraCOMPARATIVOR
(
	hora nvarchar(9),
	descripcion nvarchar(100)
)

--Insertar en la Bitacora del Comparativo de RM
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Inicia el procedimiento AF0069_ComparativoRM (INFORME GENERAL ROPA)')

-- Ventas ropa carteras del mes  
if exists(select * from SysObjects where Name = 'TmpVentasRopaCarterasMes') drop table TmpVentasRopaCarterasMes
set @Sentencia2 =  
'select NumeroTienda,FechaMovimiento,VentaTotal = (Importe+Interes),FacturaoNota  
into TmpVentasRopaCarterasMes  
from Cargas' + @Ano +'.dbo.ctlcargatransacciones 
where ClaveMovimiento+TipoMovimiento in (select ClaveMovimiento+TipoMovimiento from dbo.catComparativo where area = ''Ropa'') and FechaMovimiento between ''' + @FechaInicio + ''' and ''' + @FechaFin  + ''''
exec (@Sentencia2)

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Ventas ropa carteras del mes (ctlcargatransacciones)')

set @opendatasource = @opendatasource+@ip+'; user id='+@id+'; password='+@pass
if exists(select * from SysObjects where Name = 'TmpVentasInvRopaMes') drop table TmpVentasInvRopaMes
-- Ventas Inv. Ropa Del Mes  
set @Sentencia =  '
select NumTienda,FechaVenta, PrecioVentaTotal  
into dbo.TmpVentasInvRopaMes  
from opendatasource(''sqloledb'','''+@opendatasource+''').sisropa.dbo.vis_ctlventasropa'
exec (@Sentencia)

-- Dejo la mista tienda/fecha de lo trabajado en carteras  
Delete From TmpVentasInvRopaMes  
Where Not Exists (Select * From TmpVentasRopaCarterasMes Where numerotienda = TmpVentasInvRopaMes.numtienda and FechaMovimiento = TmpVentasInvRopaMes.FechaVenta) 

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Ventas inv. ropa del mes OPENDATASOURCE (dbo.vis_ctlventasropa)')

-- Se deja al nivel tienda - dia  
If Exists(Select * From SysObjects Where Name = 'TmpVentasRopaCarterasMes2') Drop Table TmpVentasRopaCarterasMes2  
Select NumeroTienda,FechaMovimiento,sum(cast(VentaTotal as bigint)) as  VentaTotal  
Into dbo.TmpVentasRopaCarterasMes2  
From TmpVentasRopaCarterasMes  
Group By numerotienda,fechamovimiento

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Se deja al nivel tienda - dia ')

-- Se forma tabla con las tiendas y dias de las 2 tablas  
If Exists(Select * From SysObjects Where Name = 'TmpVentasComparacionRopaMes') Drop Table TmpVentasComparacionRopaMes  
Select distinct numtienda,FechaVenta Into dbo.TmpVentasComparacionRopaMes From TmpVentasInvRopaMes  
Union all  
Select Distinct NumeroTienda,FechaMovimiento From TmpVentasRopaCarterasMes2 

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Se forma tabla con las tiendas y dias de las 2 tablas')  

-- Se quedan las tiendas y dias sin repetir  
If Exists(Select * From SysObjects Where Name = 'TmpVentasComparacionRopaMes2') Drop Table TmpVentasComparacionRopaMes2  
Select distinct * Into dbo.TmpVentasComparacionRopaMes2 From TmpVentasComparacionRopaMes  

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Se quedan las tiendas y dias sin repetir')  

-- Tabla para informe de ventas de ropa recibidas y procesadas  
If Exists(Select * From SysObjects Where Name = 'TmpVentasComparacionRopaFinal') Drop Table TmpVentasComparacionRopaFinal  
Select a.*,isnull(b.PrecioVentaTotal,0) VentaInvRopa,isnull(c.VentaTotal,0) VentaRopaCarteras,Diferencia = (isnull(c.VentaTotal,0)-isnull(b.PrecioVentaTotal,0))  
Into dbo.TmpVentasComparacionRopaFinal -- 820  
From TmpVentasComparacionRopaMes2 a left join TmpVentasInvRopaMes b on (a.numtienda = b.NumTienda and a.fechaventa = b.FechaVenta)  
               left join TmpVentasRopaCarterasMes2 c on (a.numtienda = c.NumeroTienda and a.fechaventa = c.FechaMovimiento)  
Order By a.FechaVenta,a.numtienda  

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Tabla para informe de ventas de ropa recibidas y procesadas')

-- Elimino donde no hay informacion a comparar  
Delete from TmpVentasComparacionRopaFinal where Diferencia = 0 or VentaInvRopa = 0 or VentaRopaCarteras = 0

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Fin del proceso: General ventas ropa')
  

-------------------------------VENTAS ROPA DETALLADO POR FACTURA O NOTA------------------------------------
--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Inicia proceso ropa detallado por factura o nota')

-- Se agarran las tiendas a detalle que tuvieron diferencia  
If Exists(Select * From SysObjects Where Name = 'TmpVentasRopaCarterasDetalleMes') Drop Table TmpVentasRopaCarterasDetalleMes  
Select Numerotienda,FechaMovimiento,FacturaoNota,sum(VentaTotal) as VentaTotal  
Into dbo.TmpVentasRopaCarterasDetalleMes   
From TmpVentasRopaCarterasMes a  
Where Exists (Select * From TmpVentasComparacionRopaFinal Where numtienda = A.NumeroTienda and FechaVenta = A.FechaMovimiento)  
group by Numerotienda,FechaMovimiento,FacturaoNota  

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Se agarran las tiendas a dellate que tuvieron diferencias')

-- Se traen las ventas de inv. ropa a nivel detalle  
If Exists(Select * From SysObjects Where Name = 'TmpVentasInvRopaDetalleMes') Drop Table TmpVentasInvRopaDetalleMes  
set @Sentencia =  '
Select a.NumTienda,a.FechaVenta,a.NumNota,sum(a.PrecioVenta) as PrecioVenta  
Into dbo.TmpVentasInvRopaDetalleMes  
From opendatasource(''sqloledb'','''+@opendatasource+''').'+@BaseDatos+'.dbo.Vis_CtlVentasRopaDetalle a 
where exists (select * from TmpVentasComparacionRopaFinal where numtienda=A.numtienda and fechaventa = A.FechaVenta)
group by a.NumTienda,a.FechaVenta,a.NumNota'
exec (@Sentencia)

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Se traen las ventas del inv. ropa a nivel detalle con un OPENDATASOURCE: Vis_CtlVentasRopaDetalle')		

-- Se forma tabla con las tiendas,dias y facturas de las 2 tablas  
If Exists(Select * From SysObjects Where Name = 'TmpVentasComparacionRopaDetalleMes') Drop Table TmpVentasComparacionRopaDetalleMes  
Select Distinct Numerotienda,FechaMovimiento,FacturaoNota,VentaInvRopaDetalle = cast (0 as bigint),VentaRopaCarterasDetalle = cast(0 as bigint) Into dbo.TmpVentasComparacionRopaDetalleMes From TmpVentasRopaCarterasDetalleMes  
Union all --   
Select Distinct NumTienda,FechaVenta,NumNota,VentaInvRopaDetalle = cast (0 as bigint),VentaRopaCarterasDetalle = cast(0 as bigint) From TmpVentasInvRopaDetalleMes  

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Se forma tabla con las tiendas, dias y factuars de las dos tablas')
 
-- Se quedan las tiendas y dias sin repetir  
If Exists(Select * From SysObjects Where Name = 'TmpVentasComparacionRopaDetalleMes2') Drop Table TmpVentasComparacionRopaDetalleMes2  
Select distinct * Into dbo.TmpVentasComparacionRopaDetalleMes2 From TmpVentasComparacionRopaDetalleMes  

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Se quedan las tiendas y dias sin repetir')
 

-- Se actualiza la venta de inv.ropa  
Update TmpVentasComparacionRopaDetalleMes2  
Set VentaInvRopaDetalle = a. PrecioVenta  
From TmpVentasInvRopaDetalleMes a   
Where TmpVentasComparacionRopaDetalleMes2.Numerotienda = a.NumTienda and   
   TmpVentasComparacionRopaDetalleMes2.FechaMovimiento = a.FechaVenta and   
    TmpVentasComparacionRopaDetalleMes2.FacturaoNota = a.NumNota  
    
--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Se actualiza la venta de inv. ropa')
  
-- Se actualiza la venta de carteras  
Update TmpVentasComparacionRopaDetalleMes2  
Set VentaRopaCarterasDetalle = a. VentaTotal  
From TmpVentasRopaCarterasDetalleMes a   
Where TmpVentasComparacionRopaDetalleMes2.Numerotienda = a.Numerotienda and   
   TmpVentasComparacionRopaDetalleMes2.FechaMovimiento = a.FechaMovimiento and   
    TmpVentasComparacionRopaDetalleMes2.FacturaoNota = a.FacturaoNota   
  
If Exists(Select * From SysObjects Where Name = 'TmpVentasComparacionRopaDetalleFinal') Drop Table TmpVentasComparacionRopaDetalleFinal  
Select *, Diferencia = VentaRopaCarterasDetalle - VentaInvRopaDetalle  
Into dbo.TmpVentasComparacionRopaDetalleFinal  
From TmpVentasComparacionRopaDetalleMes2  
Order By FechaMovimiento,Numerotienda,FacturaoNota  

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Se actualiza la venta de carteras') 
  
Delete from TmpVentasComparacionRopaDetalleFinal where diferencia = 0

--Insertar en la Bitacora del Comparativo de RM
set @hora =  (select CONVERT(nvarchar(40),getdate(),108))
insert into dbo.BitacoraCOMPARATIVOR
values (@hora,'Fin del proceso: ropa detallado por factura o nota') 

/*===============================================================================================*/  
/*                                  Limpiando Temporales                                         */  
/*===============================================================================================*/  
if exists(select * from SysObjects where Name = 'TmpVentasRopaCarterasMes') drop table TmpVentasRopaCarterasMes  
if exists(select * from SysObjects where Name = 'TmpVentasInvRopaMes') drop table TmpVentasInvRopaMes  
if exists(select * from SysObjects where Name = 'TmpVentasRopaCarterasMes2') drop table TmpVentasRopaCarterasMes2  
if exists(select * from SysObjects where Name = 'TmpVentasComparacionRopaMes') drop table TmpVentasComparacionRopaMes
if exists(select * from SysObjects where Name = 'TmpVentasComparacionRopaMes2') drop table TmpVentasComparacionRopaMes2  
if exists(select * from SysObjects where Name = 'TmpVentasRopaCarterasDetalleMes') drop table TmpVentasRopaCarterasDetalleMes
if Exists(select * from SysObjects where Name = 'TmpVentasInvRopaDetalleMes') drop table TmpVentasInvRopaDetalleMes     
if exists(select * from SysObjects where Name = 'TmpVentasComparacionRopaDetalleMes') drop table TmpVentasComparacionRopaDetalleMes 
if exists(select * from SysObjects where Name = 'TmpVentasComparacionRopaDetalleMes2') drop table TmpVentasComparacionRopaDetalleMes2  

end
GO
