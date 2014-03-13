using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace AF0069_ComparativoRM
{
    public partial class HistoricaMuebles : Form
    {
        ConexionSQL con = new ConexionSQL();
        SqlConnection cn11 = new SqlConnection();
        SqlConnection cnMuebles = new SqlConnection();
        SqlCommand cmMuebles = new SqlCommand();
        SqlCommand cm11 = new SqlCommand();

        public HistoricaMuebles()
        {
            InitializeComponent();
        }

        private void bDepurar_Click(object sender, EventArgs e)
        {
            DateTime fecha = dtPickerFecha.Value.Date;
            int mes = fecha.Month;
            int a�onum = fecha.Year;
            string a�o = fecha.Year.ToString();
            string mesNombre = "";
            string nombretabla = "";
            string cadena = "";
            mesNombre = fecha.ToString("MMM");

            if (mes == 01)
                mesNombre = "Ene";
            if (mes == 04)
                mesNombre = "Abr";
            if (mes == 08)
                mesNombre = "Ago";
            if (mes == 12)
                mesNombre = "Dic";

            mesNombre = UppercaseFirst(mesNombre);

            string mesa�o = mesNombre + a�o;
            nombretabla = "AF0069_HistoricaMuebles_" + mesa�o;
            cadena = "if exists (select * from sysobjects where name = '" + nombretabla + "') drop table " + nombretabla;
            cn11.ConnectionString = con.LeeArchivo("C:/Sys/Exe/Conexion/ConexionComparativoRM.txt");
            cn11.Open();
            cm11.Connection = cn11;
            cm11.CommandTimeout = 0;
            cm11.CommandType = CommandType.Text;

            cm11.CommandText = cadena;
            cm11.ExecuteNonQuery();
            MessageBox.Show("La tabla " + nombretabla + " fue eliminada","Notificaci�n");
            cn11.Close();
        }

        private void bGenerar_Click(object sender, EventArgs e)
        {
            
            this.lbinicio.Text = "--";
            this.lbfinal.Text = "--";
            bRespaldar.Enabled = false;

            this.Cursor = Cursors.WaitCursor;
            lbestatus.Visible = true;
            lbinicio.Text = DateTime.Now.ToShortTimeString();
            Refresh();
            
            DateTime fecha = dtPickerFecha.Value.Date;
            int mes = fecha.Month;
            int a�onum = fecha.Year;
            string a�o = fecha.Year.ToString();
            string mesNombre = "";
            string tabladestino = "";
            string cadena = "";
            mesNombre = fecha.ToString("MMM");

            if (mes == 01)
                mesNombre = "Ene";
            if (mes == 04)
                mesNombre = "Abr";
            if (mes == 08)
                mesNombre = "Ago";
            if (mes == 12)
                mesNombre = "Dic";

            mesNombre = UppercaseFirst(mesNombre);

            string mesa�o = mesNombre + a�o;
            tabladestino = "AF0069_HistoricaMuebles_" + mesa�o;
            cn11.ConnectionString = con.LeeArchivo("C:/Sys/Exe/Conexion/ConexionComparativoRM.txt");
            cn11.Open();
            cm11.Connection = cn11;
            cm11.CommandTimeout = 0;
            cm11.CommandType = CommandType.Text;

            cadena = "if exists (select * from sysobjects where name = 'AF0069_HistoricaMuebles_" 
            + mesa�o + "') drop table AF0069_HistoricaMuebles_" + mesa�o + " create table AF0069_HistoricaMuebles_" + mesa�o
            + "(Tienda int, Fecha smalldatetime, Venta bigint, Devoluciones bigint, TiempoAire bigint, TaSinCosto int, Complemento int, Fecha_Corte smalldatetime, Ajustes int)";

            cm11.CommandText = cadena;
            cm11.ExecuteNonQuery();

            SqlConnection C = new SqlConnection();
            C = cn11;

            cnMuebles.ConnectionString = con.LeeArchivo("C:/Sys/Exe/Conexion/ConexionInvMuebles.txt");
            cnMuebles.Open();
            cmMuebles.Connection = cnMuebles;
            cmMuebles.CommandTimeout = 0;
            cmMuebles.CommandType = CommandType.Text;

            SqlDataAdapter ad = new SqlDataAdapter();
            DataTable dt = new DataTable();
            cmMuebles.CommandText = "Sp_ComparativoCarterasMuebles " + mes + "," + a�onum;
            ad.SelectCommand = cmMuebles;
            ad.Fill(dt);
            SqlBulkCopy bc = new SqlBulkCopy(C);
            bc.BatchSize = 200;
            bc.BulkCopyTimeout = 0;
            bc.DestinationTableName = tabladestino;
            bc.WriteToServer(dt);
            dt.Reset();

            cnMuebles.Close();
            cn11.Close();

            MessageBox.Show("Se respaldo la tabla " + tabladestino, "Notificaci�n");
            lbestatus.Visible = false;
            lbfinal.Text = DateTime.Now.ToShortTimeString();
            Refresh();
            bRespaldar.Enabled = true;
            Cursor = Cursors.Default;

        }

        static string UppercaseFirst(string s)
        {
            if (string.IsNullOrEmpty(s))
            {
                return string.Empty;
            }
            return char.ToUpper(s[0]) + s.Substring(1);
        }


    }
}