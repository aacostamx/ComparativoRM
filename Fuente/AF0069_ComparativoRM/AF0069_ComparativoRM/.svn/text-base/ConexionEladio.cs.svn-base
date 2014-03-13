using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace AF0069_ComparativoRM
{
    class ConexionEladio
    {
        private string CatalogoInicial;
        private string Fuente;
        private string UID;
        private string Pwd;
        private SqlConnection con = new SqlConnection();
        private string Conexion;
        private SqlCommand comm = new SqlCommand();
        private SqlDataAdapter da = new SqlDataAdapter();

        public SqlDataAdapter Da
        {
            get { return da; }
            set { da = value; }
        }

        public SqlCommand Comm
        {
            get { return comm; }
            set { comm = value; }
        }

        public string Conexion1
        {
            get { return Conexion; }
            set { Conexion = value; }
        }

        public SqlConnection Con
        {
            get { return con; }
            set { con = value; }
        }

        public string Pwd1
        {
            get { return Pwd; }
            set { Pwd = value; }
        }

        public string UID1
        {
            get { return UID; }
            set { UID = value; }
        }

        public string Fuente1
        {
            get { return Fuente; }
            set { Fuente = value; }
        }

        public string CatalogoInicial1
        {

            get { return CatalogoInicial; }
            set { CatalogoInicial = value; }
        }
        
        public ConexionEladio(string InitialCatalog, string DataSource, string User, string Password)
        {
            CatalogoInicial1 = InitialCatalog;
            Fuente1 = DataSource;
            UID1 = User;
            Pwd1 = Password;
            //UID1 = "prueba";
            //Pwd1 = "prueba";
            Conexion1 = "Initial Catalog=" + CatalogoInicial1 + ";Data Source=" + Fuente1 + ";UID=" + UID1 + ";Pwd=" + Pwd1;
            //Conexion = new Rutinas().LeeArchivoConexion("Conexion.txt");
            Conectar();
        }

        public ConexionEladio()
        {
            //CatalogoInicial1 = InitialCatalog;
            //Fuente1 = DataSource;
            //UID1 = User;
            //Pwd1 = Password;
            //Conexion1 = "Initial Catalog=" + CatalogoInicial1 + ";Data Source=" + Fuente1 + ";UID=" + UID1 + ";Pwd=" + Pwd1;
            Conexion = new Rutinas().LeeArchivoConexion("C://pventa//Conexion.txt");
            Conectar();
        }
       
        private void Conectar()
        {
            Con.ConnectionString = Conexion1;
        }

        private void ConexionAbrir()
        {
            if (Con.State == ConnectionState.Closed)
             Con.Open(); 

        }

        private void ConexionCerrar()
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }

        public DataTable Execute(ref DataTable dtTienda, string Sentencia)
        {
            try
            {
                ConexionAbrir();
                Comm.CommandType = CommandType.Text;
                Comm.CommandText = Sentencia;
                Comm.CommandTimeout = 10000;
                Da.SelectCommand = Comm;
                Da.SelectCommand.Connection = Con;
                Da.SelectCommand.CommandTimeout = 10000;
                Da.Fill(dtTienda);
                return dtTienda;
            }
            catch (Exception ex) { throw ex; }
            finally { ConexionCerrar(); }
        }

        public void Execute(string Sentencia)
        {
            try
            {
                ConexionAbrir();
                Comm.CommandType = CommandType.Text;
                Comm.CommandText = Sentencia;
                Comm.Connection = Con;
                Comm.CommandTimeout = 10000;
                Comm.ExecuteNonQuery();
                           }
            catch (Exception ex) { throw ex; }
            finally { ConexionCerrar(); }
        }
    }
}
