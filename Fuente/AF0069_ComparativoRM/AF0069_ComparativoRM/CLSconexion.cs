using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Odbc;
using System.Windows.Forms;
using System.Threading;


namespace AF0069_ComparativoRM
{
    class CLSconexion
    {
        OdbcConnection vlsconection;

        //Realiza la conexion
        public void Abrirconexion(string str)
        {
            try
            {
                vlsconection = new OdbcConnection("Driver=PostgreSQL ANSI;UID=syscarterassolicitudesro;Password=add70f61610f55fdd933f6cc9a9ef2df;Database=solicitudes;Server=" + str);
                vlsconection.ConnectionTimeout = 0;
                if (vlsconection.State == ConnectionState.Closed)
                    vlsconection.Open();

            }
            catch
            {
                MessageBox.Show("¡¡¡NO SE PUDO ESTABLECER CONEXION CON EL SERVIDOR" + str + "", "Finalizado", MessageBoxButtons.OK, MessageBoxIcon.Error);

            }
        }
    }
}
