Manuel
---------------------------------------------------------------------------------------------------------------------------

declare @varFYear                 varchar(4), @varFMes int,                              @varFechaInicioCarga varchar(8), 
           @varFechaTopeCarga     varchar(8), @varSemana     int,                              @FechaHoy varchar(8),
           @FechaHoy_dt           datetime,    @FechaTraspasoOracle varchar(8),    @FechaTraspasoOracle_dt datetime,
             @TipoCierre varchar(1),                 @FechaCierreAnticipado date;


--set @FechaHoy_dt = getdate()
set @FechaHoy_dt = convert(varchar, '20211001', 112)

set @FechaHoy =  CONVERT(NUMERIC(8,0), CONVERT(VARCHAR(8), @FechaHoy_dt,112))
set @varFechaTopeCarga = CONVERT(VARCHAR(8), DATEADD(day, -1,@FechaHoy_dt),112)

--select 'FechaTope',  @varFechaTopeCarga

--==============================================================================================
-- Obtiene la fecha del cierre anticipado anterior para obtener la fecha inicial de proceso

       set @FechaCierreAnticipado = DATEADD(month, -1, @varFechaTopeCarga );

       --select 'fechacierre anticipado', @FechaCierreAnticipado
       select   @varFechaInicioCarga = CONVERT(VARCHAR(25),desde,112)
       from CLSTGO0CTRL6.cgestion.dbo.cg_semanas
       where calendario = 1
       and   year(desde) = year(@FechaCierreAnticipado)
       and month(desde) = MONTH(@FechaCierreAnticipado)
       and  TipoCierre = 'A'

--select 'fechahoy_dt', @FechaHoy_dt, 'FechaCierreAnticipado', @FechaCierreAnticipado, 'Fechainicio', @varFechaInicioCarga
--==============================================================================================

--select 'FechainiciCarga_1', @varFechaInicioCarga
if isnull(@varFechaInicioCarga,'') = ''
       begin
       set @varFechaInicioCarga = convert(varchar(8), convert(char(4), YEAR(@FechaHoy_dt)) + 
        case
         when month(@FechaHoy_dt) < 10 then  convert(char(2), '0' + convert(char, month(@FechaHoy_dt)))
         else convert(char(2), month(@FechaHoy_dt))
       end
       + convert(char(2), '01'), 112)
       end

--select 'FechainiciCarga_1', @varFechaInicioCarga

--set @varFechaInicioCarga = 20210701
--set @varFechaTopeCarga = 20210731



       select   @FechaTraspasoOracle = CONVERT(NUMERIC(8,0), CONVERT(VARCHAR(8), FechaTraspasoOracle,112)),
         @FechaTraspasoOracle_dt = FechaTraspasoOracle,
         @varSemana = semana,
         @TipoCierre = TipoCierre
       from CLSTGO0CTRL6.cgestion.dbo.cg_semanas
       where calendario = 1
       and  @varFechaTopeCarga between desde and hasta



select  @varFYear =  fyear, 
@varFMes = fmes
from CLSTGO0DWH02.cgestion.dbo.MIS_DT_TIEMPO
where
  year(fecha) = year(@FechaTraspasoOracle_dt) 
and month(fecha) = month(@FechaTraspasoOracle_dt) 


select @varFYear FYear, @varFMes Fmes, @varFechaInicioCarga FechaInicioCarga, 
  @varFechaTopeCarga FechaTopeCarga, @varSemana Semana, 
  @FechaHoy FechaHoy, @FechaHoy_dt FechaHoy_dt,
  @FechaTraspasoOracle FechaTraspasoOracle,
  @FechaTraspasoOracle_dt FechaTraspasoOracle_dt,
  @TipoCierre as TipoCierre

