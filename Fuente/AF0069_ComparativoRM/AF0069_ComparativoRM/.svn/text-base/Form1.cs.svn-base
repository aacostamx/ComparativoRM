using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Odbc;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Threading;
using System.Diagnostics;
using System.IO;
using System.Net.NetworkInformation;
using System.Globalization;
using System.Net;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//AUTOR:    Antonio Acosta Murillo                                                                          //
//OBJETIVO: Generar comparativo de ropa y muebles                                                           //        
//FECHA:    07 Agosto 2013                                                                                  //
//PAIS:     Mexico                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


namespace AF0069_ComparativoRM
{
    public partial class Form1 : Form
    {
        ConexionSQL con = new ConexionSQL();
        SqlConnection cn11 = new SqlConnection();
        SqlCommand cm11 = new SqlCommand();

        SqlConnection CnMuebles = new SqlConnection();
        SqlConnection cnMuebles = new SqlConnection();
        SqlConnection cnRopa = new SqlConnection();
        ConexionSQL conRopa = new ConexionSQL();
        SqlCommand CmMuebles = new SqlCommand();

        SqlTransaction tran;

        SqlCommand cm = new SqlCommand();
        SqlConnection Cn = new SqlConnection();
        SqlDataAdapter Da = new SqlDataAdapter();
        ConexionSQL Con = new ConexionSQL();

        DataTable TablaDatos = new DataTable();
        CrystalDecisions.CrystalReports.Engine.ReportDocument Rpt1 = new CrystalDecisions.CrystalReports.Engine.ReportDocument();
        CrystalDecisions.CrystalReports.Engine.ReportDocument Rpt2 = new CrystalDecisions.CrystalReports.Engine.ReportDocument();
        CrystalDecisions.CrystalReports.Engine.ReportDocument Rpt3 = new CrystalDecisions.CrystalReports.Engine.ReportDocument();
        CrystalDecisions.CrystalReports.Engine.ReportDocument Rpt4 = new CrystalDecisions.CrystalReports.Engine.ReportDocument();

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.label3.Text = "--";
            this.label4.Text = "--";

            this.Cursor = Cursors.WaitCursor;
            label5.Visible = true;
            label3.Text = DateTime.Now.ToShortTimeString();
            Refresh();

            button1.Enabled = false;
            dateTimePicker1.Enabled = false;
            dateTimePicker2.Enabled = false;
            Refresh();

          if (checkBox1.Checked == true)
                ComparativoRopaGeneral();

          if (checkBox2.Checked == true)
                ComparativoRopaDetalle();

          if (checkBox3.Checked == true)
                ComparativoMueblesDetalle();

          if (checkBox4.Checked == true)
                ComparativoMueblesGeneral();

           Refresh();
        }

        private void ComparativoMueblesGeneral()
        {
            string FechaInicio = dateTimePicker1.Value.Year.ToString() + '-' + dateTimePicker1.Value.Month.ToString().PadLeft(2, '0') + '-' + dateTimePicker1.Value.Day.ToString().PadLeft(2, '0');
            string FechaFin = dateTimePicker2.Value.Year.ToString() + '-' + dateTimePicker2.Value.Month.ToString().PadLeft(2, '0') + '-' + dateTimePicker2.Value.Day.ToString().PadLeft(2, '0');

            DateTime fInicio = Convert.ToDateTime(FechaInicio);
            string ParametroFechaInicio = fInicio.ToString("dd-MM-yyyy");

            DateTime fFin = Convert.ToDateTime(FechaFin);
            string ParametroFechaFin = fFin.ToString("dd-MM-yyyy");

            string mes = FechaInicio.Substring(5, 2);
            string año = FechaInicio.Substring(0, 4);

            cn11.ConnectionString = con.LeeArchivo("C:/Sys/Exe/Conexion/ConexionCT11.txt");

            cn11.Open();
            string IpControl = con.IP;
            string BdControl = con.DB;
            string UserControl = con.USER;
            string PwdControl = con.PASS;
            cm11.Connection = cn11;
            cm11.CommandTimeout = 0;
            cm11.CommandType = CommandType.Text;

            cm11.CommandText = "If Exists (Select * From Sysobjects Where name = 'TmpVentasInvMuebles') Drop Table TmpVentasInvMuebles Create Table dbo.TmpVentasInvMuebles(Tienda bigint,Fecha smalldatetime,Venta bigint,Devoluciones bigint,TiempoAire  bigint,TaSinCosto bigint,Complemento bigint,FechaCorte smalldatetime,Ajuste bigint)";
            cm11.ExecuteNonQuery();

            cm11.CommandText = "If Exists (Select * From Sysobjects Where name = 'TmpVentasInvMueblesDetalleMes') Drop Table TmpVentasInvMueblesDetalleMes Create Table dbo.TmpVentasInvMueblesDetalleMes(Tienda bigint,Fecha smalldatetime,TipoMov varchar(4),Folio bigint,TotalFacturado bigint)";
            cm11.ExecuteNonQuery();
            SqlConnection C = new SqlConnection();
            C = cn11;

            CnMuebles.ConnectionString = con.LeeArchivo("C:/Sys/Exe/Conexion/ConexionInvMuebles.txt");

            CnMuebles.Open();
            CmMuebles.Connection = CnMuebles;
            CmMuebles.CommandTimeout = 0;
            CmMuebles.CommandType = CommandType.Text;

            // Obtengo Las Ventas De Inv Muebles
            SqlDataAdapter Ad = new SqlDataAdapter();
            DataTable G = new DataTable();
            CmMuebles.CommandText = "exec Sp_ComparativoCarterasMuebles " + mes + "," + año;
            Ad.SelectCommand = CmMuebles;
            Ad.Fill(G);
            SqlBulkCopy bc = new SqlBulkCopy(C);
            bc.BatchSize = 200;
            bc.BulkCopyTimeout = 0;
            bc.DestinationTableName = "TmpVentasInvMuebles";
            bc.WriteToServer(G);
            G.Reset();
            CnMuebles.Close();
            cm11.CommandText = "Exec old_AF0069_ComparativoMuebles2" + "'" + FechaInicio + "'" + ", " + "'" + FechaFin + "'";
            cm11.ExecuteNonQuery();
            cm11.CommandText = "Select * from QueryInvMueblesMes";
            DataTable dtinvmue = new DataTable();
            Ad.SelectCommand = cm11;
            Ad.Fill(dtinvmue);

            CnMuebles.ConnectionString = con.LeeArchivo("C:/Sys/Exe/Conexion/ConexionInvMueblesDetalle.txt");
            CnMuebles.Open();
            CmMuebles.Connection = CnMuebles;
            CmMuebles.CommandTimeout = 0;
            CmMuebles.CommandType = CommandType.Text;

            // Me Traigo Las Ventas A Detalle De Las Tiendas Que Hay Diferencias
            for (int i = 0; i < dtinvmue.Rows.Count; i++)
            {
                if (dtinvmue.Rows[i]["FlagVenta"].ToString().Trim() == "1")
                {
                    CmMuebles.CommandText = dtinvmue.Rows[i]["ExecProc"].ToString().Trim() + "," + 1;
                    Ad.SelectCommand = CmMuebles;
                    Ad.Fill(G);
                    tran = CnMuebles.BeginTransaction();
                    bc.DestinationTableName = "TmpVentasInvMueblesDetalleMes";
                    bc.WriteToServer(G);
                    tran.Commit();
                    G.Reset();
                }
                if (dtinvmue.Rows[i]["FlagTA"].ToString().Trim() == "1")
                {
                    CmMuebles.CommandText = dtinvmue.Rows[i]["ExecProc"].ToString().Trim() + "," + 2;
                    Ad.SelectCommand = CmMuebles;
                    Ad.Fill(G);
                    tran = CnMuebles.BeginTransaction();
                    bc.DestinationTableName = "TmpVentasInvMueblesDetalleMes";
                    bc.WriteToServer(G);
                    tran.Commit();
                    G.Reset();
                }
                if (dtinvmue.Rows[i]["FlagDev"].ToString().Trim() == "1")
                {
                    CmMuebles.CommandText = dtinvmue.Rows[i]["ExecProc"].ToString().Trim() + "," + 3;
                    Ad.SelectCommand = CmMuebles;
                    Ad.Fill(G);
                    tran = CnMuebles.BeginTransaction();
                    bc.DestinationTableName = "TmpVentasInvMueblesDetalleMes";
                    bc.WriteToServer(G);
                    tran.Commit();
                    G.Reset();
                }
            }

            G.Reset();
            CnMuebles.Close();
            Cn.Close();

            ConexionEladio eCon = new ConexionEladio("ComparativoRM", IpControl, UserControl, PwdControl);
            DataTable dt = new DataTable();

            eCon.Execute("Exec old_AF0069_ComparativoMueblesDetalle2");

            //cm11.CommandText = "Exec AF0069_ComparativoMueblesDetalle";
            //cm11.ExecuteNonQuery();

            // Reporte Mensual Muebles
            Rpt3.FileName = "C:/Sys/Crystal/AF0069_VentasMuebles.rpt";
            Rpt3.DataSourceConnections[0].SetConnection(IpControl, BdControl, UserControl, PwdControl);
            Rpt3.Refresh();
            Rpt3.SetDatabaseLogon(UserControl, PwdControl);
            Rpt3.SetParameterValue("fechainicio", FechaInicio);
            Rpt3.SetParameterValue("fechafinal", FechaFin);
            Rpt3.ExportToDisk(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat, "AF0069_VentasMuebles" + ".pdf");

            Refresh();

            label4.Text = DateTime.Now.ToShortTimeString();
            MessageBox.Show("Reporte generado", "Notificación");
            Refresh();
            Cursor = Cursors.Default;
            label5.Visible = false;

            Refresh();
            button1.Enabled = true;
            dateTimePicker1.Enabled = true;
            dateTimePicker2.Enabled = true;
        }

        private void ComparativoMueblesDetalle()
        {
            string FechaInicio = dateTimePicker1.Value.Year.ToString() + '-' + dateTimePicker1.Value.Month.ToString().PadLeft(2, '0') + '-' + dateTimePicker1.Value.Day.ToString().PadLeft(2, '0');
            string FechaFin = dateTimePicker2.Value.Year.ToString() + '-' + dateTimePicker2.Value.Month.ToString().PadLeft(2, '0') + '-' + dateTimePicker2.Value.Day.ToString().PadLeft(2, '0');

            DateTime fInicio = Convert.ToDateTime(FechaInicio);
            string ParametroFechaInicio = fInicio.ToString("dd-MM-yyyy");

            DateTime fFin = Convert.ToDateTime(FechaFin);
            string ParametroFechaFin = fFin.ToString("dd-MM-yyyy");

            string mes = FechaInicio.Substring(5, 2);
            string año = FechaInicio.Substring(0, 4);

            cn11.ConnectionString = con.LeeArchivo("C:/Sys/Exe/Conexion/ConexionCT11.txt");

            cn11.Open();
            string IpControl = con.IP;
            string BdControl = con.DB;
            string UserControl = con.USER;
            string PwdControl = con.PASS;
            cm11.Connection = cn11;
            cm11.CommandTimeout = 0;
            cm11.CommandType = CommandType.Text;

            cm11.CommandText = "If Exists (Select * From Sysobjects Where name = 'TmpVentasInvMuebles') Drop Table TmpVentasInvMuebles Create Table dbo.TmpVentasInvMuebles(Tienda bigint,Fecha smalldatetime,Venta bigint,Devoluciones bigint,TiempoAire  bigint,TaSinCosto bigint,Complemento bigint,FechaCorte smalldatetime,Ajuste bigint)";
            cm11.ExecuteNonQuery();

            cm11.CommandText = "If Exists (Select * From Sysobjects Where name = 'TmpVentasInvMueblesDetalleMes') Drop Table TmpVentasInvMueblesDetalleMes Create Table dbo.TmpVentasInvMueblesDetalleMes(Tienda bigint,Fecha smalldatetime,TipoMov varchar(4),Folio bigint,TotalFacturado bigint)";
            cm11.ExecuteNonQuery();
            SqlConnection C = new SqlConnection();
            C = cn11;

            CnMuebles.ConnectionString = con.LeeArchivo("C:/Sys/Exe/Conexion/ConexionInvMuebles.txt");
            
            CnMuebles.Open();
            CmMuebles.Connection = CnMuebles;
            CmMuebles.CommandTimeout = 0;
            CmMuebles.CommandType = CommandType.Text;

            // Obtengo Las Ventas De Inv Muebles
            SqlDataAdapter Ad = new SqlDataAdapter();
            DataTable G = new DataTable();
            CmMuebles.CommandText = "exec Sp_ComparativoCarterasMuebles " + mes + "," + año;
            Ad.SelectCommand = CmMuebles;
            Ad.Fill(G);
            SqlBulkCopy bc = new SqlBulkCopy(C);
            bc.BatchSize = 200;
            bc.BulkCopyTimeout = 0;
            bc.DestinationTableName = "TmpVentasInvMuebles";
            bc.WriteToServer(G);
            G.Reset();
            CnMuebles.Close();
            cm11.CommandText = "Exec old_AF0069_ComparativoMuebles2" + "'" + FechaInicio + "'" + ", " + "'" + FechaFin + "'";
            cm11.ExecuteNonQuery();
            cm11.CommandText = "Select * from QueryInvMueblesMes";
            DataTable dtinvmue = new DataTable();
            Ad.SelectCommand = cm11;
            Ad.Fill(dtinvmue);

            CnMuebles.ConnectionString = con.LeeArchivo("C:/Sys/Exe/Conexion/ConexionInvMueblesDetalle.txt");
            CnMuebles.Open();
            CmMuebles.Connection = CnMuebles;
            CmMuebles.CommandTimeout = 0;
            CmMuebles.CommandType = CommandType.Text;

            // Me Traigo Las Ventas A Detalle De Las Tiendas Que Hay Diferencias
            for (int i = 0; i < dtinvmue.Rows.Count; i++)
            {
                if (dtinvmue.Rows[i]["FlagVenta"].ToString().Trim() == "1")
                {
                    CmMuebles.CommandText = dtinvmue.Rows[i]["ExecProc"].ToString().Trim() + "," + 1;
                    Ad.SelectCommand = CmMuebles;
                    Ad.Fill(G);
                    tran = CnMuebles.BeginTransaction();
                    bc.DestinationTableName = "TmpVentasInvMueblesDetalleMes";
                    bc.WriteToServer(G);
                    tran.Commit();
                    G.Reset();
                }
                if (dtinvmue.Rows[i]["FlagTA"].ToString().Trim() == "1")
                {
                    CmMuebles.CommandText = dtinvmue.Rows[i]["ExecProc"].ToString().Trim() + "," + 2;
                    Ad.SelectCommand = CmMuebles;
                    Ad.Fill(G);
                    tran = CnMuebles.BeginTransaction();
                    bc.DestinationTableName = "TmpVentasInvMueblesDetalleMes";
                    bc.WriteToServer(G);
                    tran.Commit();
                    G.Reset();
                }
                if (dtinvmue.Rows[i]["FlagDev"].ToString().Trim() == "1")
                {
                    CmMuebles.CommandText = dtinvmue.Rows[i]["ExecProc"].ToString().Trim() + "," + 3;
                    Ad.SelectCommand = CmMuebles;
                    Ad.Fill(G);
                    tran = CnMuebles.BeginTransaction();
                    bc.DestinationTableName = "TmpVentasInvMueblesDetalleMes";
                    bc.WriteToServer(G);
                    tran.Commit();
                    G.Reset();
                }
            }

            G.Reset();
            CnMuebles.Close();
            Cn.Close();

            ConexionEladio eCon = new ConexionEladio("ComparativoRM", IpControl, UserControl, PwdControl);
            DataTable dt = new DataTable();

            eCon.Execute("Exec old_AF0069_ComparativoMueblesDetalle2");

            //cm11.CommandText = "Exec AF0069_ComparativoMueblesDetalle";
            //cm11.ExecuteNonQuery();

            // Reporte Mensual Muebles
            Rpt3.FileName = "C:/Sys/Crystal/AF0069_VentasMuebles.rpt";
            Rpt3.DataSourceConnections[0].SetConnection(IpControl, BdControl, UserControl, PwdControl);
            Rpt3.Refresh();
            Rpt3.SetDatabaseLogon(UserControl, PwdControl);
            Rpt3.SetParameterValue("fechainicio", FechaInicio);
            Rpt3.SetParameterValue("fechafinal", FechaFin);
            Rpt3.ExportToDisk(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat, "AF0069_VentasMuebles" + ".pdf");

            Refresh();

            
            // Reporte Muebles Detalle
            Rpt4.FileName = "C:/Sys/Crystal/AF0069_VentasMueblesDetalle.rpt";
            Rpt4.DataSourceConnections[0].SetConnection(IpControl, BdControl, UserControl, PwdControl);
            Rpt4.Refresh();
            Rpt4.SetDatabaseLogon(UserControl, PwdControl);
            Rpt4.SetParameterValue("fechainicio", FechaInicio);
            Rpt4.SetParameterValue("fechafinal", FechaFin);
            Rpt4.ExportToDisk(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat, "AF0069_VentasMueblesDetalle" + ".pdf");

            label4.Text = DateTime.Now.ToShortTimeString();
            MessageBox.Show("Reporte generado", "Notificación");
            Refresh();
            Cursor = Cursors.Default;
            label5.Visible = false;

            Refresh();
            button1.Enabled = true;
            dateTimePicker1.Enabled = true;
            dateTimePicker2.Enabled = true;
        }

        private void ComparativoRopaGeneral()
        {
            string FechaInicio = dateTimePicker1.Value.Year.ToString() + '-' + dateTimePicker1.Value.Month.ToString().PadLeft(2, '0') + '-' + dateTimePicker1.Value.Day.ToString().PadLeft(2, '0');
            string FechaFin = dateTimePicker2.Value.Year.ToString() + '-' + dateTimePicker2.Value.Month.ToString().PadLeft(2, '0') + '-' + dateTimePicker2.Value.Day.ToString().PadLeft(2, '0');
            string ip = "";
            string bd = "";
            string id = "";
            string pass = "";
            DateTime hoy = DateTime.Today;
            DateTime ultimodiames = new DateTime(hoy.Year, hoy.Month, DateTime.DaysInMonth(hoy.Year, hoy.Month));

            DateTime fInicio = Convert.ToDateTime(FechaInicio);
            string ParametroFechaInicio = fInicio.ToString("dd-MM-yyyy");

            DateTime fFin = Convert.ToDateTime(FechaFin);
            string ParametroFechaFin = fFin.ToString("dd-MM-yyyy");

            try
            {
                cnRopa.ConnectionString = conRopa.LeeArchivo(@"C:\Sys\Exe\Conexion\ConexionInvRopa.txt");
                cnRopa.Open();

                ip = conRopa.IP;
                bd = conRopa.DB;
                id = conRopa.USER;
                pass = conRopa.PASS;

            }
            catch (Exception Ex)
            {
                MessageBox.Show("Error: " + Ex.Message.ToString() + "\nSource: " + Ex.Source.ToString() + "\nMetodo: " + Ex.TargetSite.ToString());
                Cn.Close();
            }

            try
            {
                Cn.ConnectionString = Con.LeeArchivo(@"C:\Sys\Exe\Conexion\ConexionCT11.txt");
                Cn.Open();
                cm.CommandTimeout = 0;
                cm.Connection = Cn;
                cm.CommandType = CommandType.Text;

                cm.CommandText = "Exec AF0069_ComparativoRopaDetallado" + "'" + FechaInicio + "'" + ", " + "'" + FechaFin + "'" + ", " + "'" + ip + "'" + ", " + "'" + id + "'" + ", " + "'" + pass + "'" + ", " + "'" + bd + "'";
                cm.ExecuteNonQuery();

                Cn.Close();

                // Reporte Mensual Ropa
                Rpt1.FileName = "C:/Sys/Crystal/AF0069_VentasRopa.rpt";
                Rpt1.DataSourceConnections[0].SetConnection(Con.IP, Con.DB, Con.USER, Con.PASS);
                Rpt1.Refresh();
                Rpt1.SetDatabaseLogon(Con.USER, Con.PASS);
                Rpt1.PrintOptions.PaperSize = CrystalDecisions.Shared.PaperSize.PaperLetter;
                Rpt1.PrintOptions.PaperOrientation = CrystalDecisions.Shared.PaperOrientation.Portrait;
                Rpt1.SetParameterValue("fechainicio", ParametroFechaInicio);
                Rpt1.SetParameterValue("fechafinal", ParametroFechaFin);
                Rpt1.ExportToDisk(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat, "AF0069_VentasRopa" + ".pdf");

            }
            catch (Exception Ex)
            {
                MessageBox.Show("Error: " + Ex.Message.ToString() + "\nSource: " + Ex.Source.ToString() + "\nMetodo: " + Ex.TargetSite.ToString());
                Cn.Close();
            }

            //Para crear la historica al final del mes
            if (hoy == ultimodiames || hoy == ultimodiames.AddDays(1))
            {
                string fecha = DateTime.Now.ToString("yyyy-MM-dd");
                Cn.ConnectionString = Con.LeeArchivo(@"C:\Sys\Exe\Conexion\ConexionInvRopa.txt");
                ConexionEladio eCon = new ConexionEladio("ComparativoRM", Con.IP, Con.USER, Con.PASS);
                string sentencia = "AF0069_HistoricaComparativoRopa " + fecha + Con.IP + Con.USER + Con.PASS + Con.DB;
                //eCon.Execute("Exec AF0069_HistoricaComparativoRopa" +"'"+  + "'" + ", " + "'" + Con.IP + "'" + ", " + "'" + Con.USER + "'" + ", " + "'" + Con.PASS + "'" + ", " + "'" + Con.DB + "'");

            }
            cnRopa.Close();

            label4.Text = DateTime.Now.ToShortTimeString();
            MessageBox.Show("Reporte generado", "Notificación");
            Refresh();
            Cursor = Cursors.Default;
            label5.Visible = false;

            Refresh();
            button1.Enabled = true;
            dateTimePicker1.Enabled = true;
            dateTimePicker2.Enabled = true;
            Refresh();
        }

        private void ComparativoRopaDetalle()
        {
            string FechaInicio = dateTimePicker1.Value.Year.ToString() + '-' + dateTimePicker1.Value.Month.ToString().PadLeft(2, '0') + '-' + dateTimePicker1.Value.Day.ToString().PadLeft(2, '0');
            string FechaFin = dateTimePicker2.Value.Year.ToString() + '-' + dateTimePicker2.Value.Month.ToString().PadLeft(2, '0') + '-' + dateTimePicker2.Value.Day.ToString().PadLeft(2, '0');
            string ip = "";
            string bd = "";
            string id = "";
            string pass = "";
            DateTime hoy = DateTime.Today;
            DateTime ultimodiames = new DateTime(hoy.Year, hoy.Month, DateTime.DaysInMonth(hoy.Year, hoy.Month));

            DateTime fInicio = Convert.ToDateTime(FechaInicio);
            string ParametroFechaInicio = fInicio.ToString("dd-MM-yyyy");

            DateTime fFin = Convert.ToDateTime(FechaFin);
            string ParametroFechaFin = fFin.ToString("dd-MM-yyyy");

            try
            { 
                cnRopa.ConnectionString = conRopa.LeeArchivo(@"C:\Sys\Exe\Conexion\ConexionInvRopa.txt");
                cnRopa.Open();
                
                ip = conRopa.IP;
                bd = conRopa.DB;
                id = conRopa.USER;
                pass = conRopa.PASS;

            }
            catch (Exception Ex)
            {
                MessageBox.Show("Error: " + Ex.Message.ToString() + "\nSource: " + Ex.Source.ToString() + "\nMetodo: " + Ex.TargetSite.ToString());
                Cn.Close();
            }

            try
            {
                Cn.ConnectionString = Con.LeeArchivo(@"C:\Sys\Exe\Conexion\ConexionCT11.txt");
                Cn.Open();
                cm.CommandTimeout = 0;
                cm.Connection = Cn;
                cm.CommandType = CommandType.Text;

                cm.CommandText = "Exec AF0069_ComparativoRopaDetallado" + "'" + FechaInicio + "'" + ", " + "'" + FechaFin + "'" + ", " + "'" + ip + "'" + ", " + "'" + id + "'" + ", " + "'" + pass + "'" + ", " + "'" + bd + "'";
                cm.ExecuteNonQuery();

                Cn.Close();
               
                // Reporte Mensual Ropa
                Rpt1.FileName = "C:/Sys/Crystal/AF0069_VentasRopa.rpt";
                Rpt1.DataSourceConnections[0].SetConnection(Con.IP, Con.DB, Con.USER, Con.PASS);
                Rpt1.Refresh();
                Rpt1.SetDatabaseLogon(Con.USER, Con.PASS);
                Rpt1.PrintOptions.PaperSize = CrystalDecisions.Shared.PaperSize.PaperLetter;
                Rpt1.PrintOptions.PaperOrientation = CrystalDecisions.Shared.PaperOrientation.Portrait;
                Rpt1.SetParameterValue("fechainicio", ParametroFechaInicio);
                Rpt1.SetParameterValue("fechafinal", ParametroFechaFin);
                Rpt1.ExportToDisk(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat, "AF0069_VentasRopa" + ".pdf");

                // Reporte Mensual Ropa Detalle
                Rpt2.FileName = "C:/Sys/Crystal/AF0069_VentasRopaDetalle.rpt";
                Rpt2.DataSourceConnections[0].SetConnection(Con.IP, Con.DB, Con.USER, Con.PASS);
                Rpt2.Refresh();
                Rpt2.SetDatabaseLogon(Con.USER, Con.PASS);
                Rpt2.PrintOptions.PaperSize = CrystalDecisions.Shared.PaperSize.PaperLetter;
                Rpt2.PrintOptions.PaperOrientation = CrystalDecisions.Shared.PaperOrientation.Portrait;
                Rpt2.SetParameterValue("fechainicio", ParametroFechaInicio);
                Rpt2.SetParameterValue("fechafinal", ParametroFechaFin);
                Rpt2.ExportToDisk(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat, "AF0069_VentasRopaDetalle" + ".pdf");
                Rpt2.Refresh();

            }
            catch (Exception Ex)
            {
                MessageBox.Show("Error: " + Ex.Message.ToString() + "\nSource: " + Ex.Source.ToString() + "\nMetodo: " + Ex.TargetSite.ToString());
                Cn.Close();
            }

            //Para crear la historica al final del mes
            if (hoy == ultimodiames || hoy == ultimodiames.AddDays(1))
            {
                string fecha = DateTime.Now.ToString("yyyy-MM-dd");
                Cn.ConnectionString = Con.LeeArchivo(@"C:\Sys\Exe\Conexion\ConexionInvRopa.txt");
                ConexionEladio eCon = new ConexionEladio("ComparativoRM", Con.IP, Con.USER, Con.PASS);
                string sentencia = "AF0069_HistoricaComparativoRopa "+ fecha + Con.IP + Con.USER + Con.PASS + Con.DB;
                //eCon.Execute("Exec AF0069_HistoricaComparativoRopa" +"'"+  + "'" + ", " + "'" + Con.IP + "'" + ", " + "'" + Con.USER + "'" + ", " + "'" + Con.PASS + "'" + ", " + "'" + Con.DB + "'");

            }

            label4.Text = DateTime.Now.ToShortTimeString();
            MessageBox.Show("Reporte generado", "Notificación");
            Refresh();
            Cursor = Cursors.Default;
            label5.Visible = false;

            Refresh();
            button1.Enabled = true;
            dateTimePicker1.Enabled = true;
            dateTimePicker2.Enabled = true;
            Refresh();
        }

        private void Form1_HelpButtonClicked(object sender, CancelEventArgs e)
        {
            Ayuda obj = new Ayuda();
            this.Hide();
            obj.ShowDialog();
            this.Show();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            HistoricaMuebles obj = new HistoricaMuebles();
            this.Hide();
            obj.ShowDialog();
            this.Show();
        }
    }
}