using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Data;
using System.IO;

namespace AF0069_ComparativoRM
{
    class Rutinas
    {
        //ClsConexxion con = new ClsConexxion();
        

        public string leeUsuario(string user)
        {
            ConexionEladio conX = new ConexionEladio();
            
            string retorno = "0";

            DataTable dt = new DataTable();
            conX.Execute(ref dt, "SELECT DERECHOS FROM usuarios WHERE NOMCORTO = '" + user.Trim() + "'");
            if (dt.Rows.Count > 0)
            {
                retorno = dt.Rows[0][0].ToString().Trim();
            }

            return retorno.Trim();

        }

        public bool isNumeric(string expresion)
        {
            Int64 var;
            return Int64.TryParse(expresion.Trim(), out var);
        }

        public bool isFloat(string expresion)
        {
            float var;
            return float.TryParse(expresion.Trim(), out var);
        }


        public string AlignCenterText(int lenght, int n)
        {
            string espacios = "";
            int spaces = (n - lenght) / 2;
            for (int x = 0; x < spaces; x++)
                espacios += " ";
            return espacios;
        }

        public string Centrar(String s, int num)
        {
            String cadena;
            cadena = AlignCenterText(s.Length, num) + s;
            return cadena;
        }


        public void crearDirectorio(string directorio)
        {
            DirectoryInfo DIR = new DirectoryInfo(directorio.Trim());

            if (!DIR.Exists)
            {
                DIR.Create();
            }
        }


        public int checa_folio_cfd()
        {
            ConexionEladio conX = new ConexionEladio();

            DataTable dtFolios = new DataTable();
            conX.Execute(ref dtFolios, "select top 1 * from catfolios where ultimofolio<foliofinal and status='A' order by consecutivo");

            int factura;
            string serie = "";
            if (dtFolios.Rows.Count > 0)
            {
                factura = Convert.ToInt32(dtFolios.Rows[0]["ultimofolio"].ToString().Trim()) + 1;
                serie = dtFolios.Rows[0]["serie"].ToString().Trim();
                DataTable dtFac = new DataTable();
                conX.Execute(ref dtFac, "select top 1 * from facturasclientes where factura=" + factura.ToString().Trim() + " and serie='" + serie.Trim() + "' and tipo<>'N'");
                if (dtFac.Rows.Count > 0)  //ya se encuentra esa factura dado de alta, eso es error
                    factura = -1;

                //ahora checa en el facturascab
                dtFac = new DataTable();
                conX.Execute(ref dtFac, "select * from facturascab where foliofactura=" + factura.ToString().Trim() + " and serie='" + serie.Trim() + "'");
                if (dtFac.Rows.Count > 0)  //ya se encuentra esa factura dado de alta, eso es error
                    factura = -1;


            }
            else
                factura = -1;   //indica que no es valido ni encontro regs en catfolios

            return factura;

        }


        public string CalculaRegistros(string Valor)
        {
            switch (Valor.Trim().Length)
            {
                case 1:
                    Valor = "00000000000000" + Valor.ToString().Trim();
                    break;
                case 2:
                    Valor = "0000000000000" + Valor.ToString().Trim();
                    break;
                case 3:
                    Valor = "000000000000" + Valor.ToString().Trim();
                    break;
                case 4:
                    Valor = "00000000000" + Valor.ToString().Trim();
                    break;
                case 5:
                    Valor = "0000000000" + Valor.ToString().Trim();
                    break;
                case 6:
                    Valor = "000000000" + Valor.ToString().Trim();
                    break;
                case 7:
                    Valor = "00000000" + Valor.ToString().Trim();
                    break;
                case 8:
                    Valor = "0000000" + Valor.ToString().Trim();
                    break;
                case 9:
                    Valor = "000000" + Valor.ToString().Trim();
                    break;
                case 10:
                    Valor = "00000" + Valor.ToString().Trim();
                    break;
                case 11:
                    Valor = "0000" + Valor.ToString().Trim();
                    break;
                case 12:
                    Valor = "000" + Valor.ToString().Trim();
                    break;
                case 13:
                    Valor = "00" + Valor.ToString().Trim();
                    break;
                case 14:
                    Valor = "0" + Valor.ToString().Trim();
                    break;
            }
            return Valor;
        }

       

        public bool ExisteCliente(string numerodecliente)
        {
            ConexionEladio conX = new ConexionEladio();

            bool resp = false;

            DataTable dt = new DataTable();
            conX.Execute(ref dt, "SELECT *  FROM clientes where numerocliente=" + numerodecliente.Trim());
            if (dt.Rows.Count > 0)
            {
                resp = true;
            }

            return resp;
        }

        public bool ExisteClienteRfc(string rfc)
        {
            ConexionEladio conX = new ConexionEladio();

            bool resp = false;

            DataTable dt = new DataTable();
            conX.Execute(ref dt, "SELECT *  FROM clientes where ltrim(rtrim(rfc))='" + rfc.Trim() + "'");
            if (dt.Rows.Count > 0)
            {
                resp = true;
            }

            return resp;
        }

        public bool TieneLimite(string numerodecliente, double ImporteVenta)
        {
            ConexionEladio conX = new ConexionEladio();

            bool resp = false;
            double limite = 0;

            DataTable dt = new DataTable();
            conX.Execute(ref dt, "SELECT *  FROM clientes where numerocliente=" + numerodecliente.Trim());

            DataTable dtSaldo = new DataTable();
            conX.Execute(ref dtSaldo, "SELECT isnull(sum(saldo),0) saldo  FROM notasclientescredito where numerocliente=" + numerodecliente.Trim());
            double saldo= Convert.ToDouble(dtSaldo.Rows[0][0].ToString().Trim());

            if (dt.Rows.Count > 0)
            {
                limite = Convert.ToDouble(dt.Rows[0]["limitecredito"].ToString().Trim());
                if ((saldo + ImporteVenta) > limite)
                {
                    resp = false;
                }
                else
                {
                    resp = true;
                }
            }

            return resp;
        }



        public string NombreCliente(string numerodecliente)
        {
            ConexionEladio conX = new ConexionEladio();

            string resp = "";

            DataTable dt = new DataTable();
            conX.Execute(ref dt, "SELECT *  FROM clientes where numerocliente=" + numerodecliente.Trim());

            if (dt.Rows.Count > 0)
            {
                resp = dt.Rows[0]["nomape2"].ToString().Trim();
            }

            return resp;
        }

        public string NombreClienteRfc(string rfc)
        {
            ConexionEladio conX = new ConexionEladio();

            string resp = "";

            DataTable dt = new DataTable();
            conX.Execute(ref dt, "SELECT *  FROM clientes where ltrim(rtrim(rfc))='" + rfc.Trim() + "'" );

            if (dt.Rows.Count > 0)
            {
                resp = dt.Rows[0]["nomape2"].ToString().Trim();
            }

            return resp;
        }


        public int PorcentajeDesctoCliente(string rfc)
        {
            ConexionEladio conX = new ConexionEladio();

            int resp = 0;

            DataTable dt = new DataTable();
            conX.Execute(ref dt, "SELECT * FROM clientes where ltrim(rtrim(rfc))='" + rfc.Trim() + "'" );

            if (dt.Rows.Count > 0)
            {
                resp = Convert.ToInt32(dt.Rows[0]["pordescto"].ToString().Trim());
            }

            return resp;
        }


        public string NombreClientePorRfc(string rfc)
        {
            ConexionEladio conX = new ConexionEladio();

            string resp = "";

            DataTable dt = new DataTable();
            conX.Execute(ref dt, "SELECT *  FROM clientes where ltrim(rtrim(rfc))='" + rfc.Trim() + "'" );

            if (dt.Rows.Count > 0)
            {
                resp = dt.Rows[0]["nomape2"].ToString().Trim();
            }

            return resp;
        }

        public int numeroClientePorRfc(string rfc)
        {
            ConexionEladio conX = new ConexionEladio();

            int resp = 0;

            DataTable dt = new DataTable();
            conX.Execute(ref dt, "SELECT *  FROM clientes where ltrim(rtrim(rfc))='" + rfc.Trim() + "'");

            if (dt.Rows.Count > 0)
            {
                resp = Convert.ToInt32(dt.Rows[0]["numerocliente"].ToString().Trim());
            }

            return resp;
        }

        public ArrayList DesglosaCadena(string Cadena, int cuantos)
        {
            Cadena += " ";
            ArrayList items = new ArrayList();

            string Lineax, Cadena2;
            bool FLAG = false;

            Lineax = "";
            Cadena2 = "";

            for (int i = 0; i <= Cadena.Length - 1; i++)
            {
                if (Cadena.Substring(i, 1) == " ")
                {
                    if (Cadena2.Length + (Lineax.Length) > cuantos)
                    //imprimelinea
                    {
                        items.Add(Lineax);
                        Lineax = Cadena2;
                        Cadena2 = "";
                        FLAG = true;
                    }
                    else
                    {
                        FLAG = true;
                        Lineax += " " + Cadena2;
                        Cadena2 = "";
                    }
                }
                else Cadena2 += Cadena.Substring(i, 1);
            }

            if (FLAG)
            {
                if ((Lineax.Length + Cadena2.Length) > cuantos)
                {
                    items.Add(Lineax);
                    items.Add(Cadena2);
                }
                else
                {
                    items.Add(Lineax);
                    if (Cadena2.Trim() != "")
                        items.Add(Cadena2);
                }
            }
            else items.Add(Cadena2);

            return items;

        }

        public double sumarCaja()
        {
            ConexionEladio con = new ConexionEladio();

            // contabiliza el dinero en efectivo de la caja
            DataTable dt = new DataTable();
            double totalCaja = 0.00;

            // EFECTIVO
            dt = new DataTable();
            con.Execute(ref dt, "SELECT ISNULL(SUM(Costot),0) FROM Ventas WHERE RTRIM(LTRIM(CorteParcial))=(SELECT TOP 1 CVE FROM Caja WHERE RTRIM(LTRIM(Status))='ABIERTA' AND ISNULL(FechaFIn,'19000101')='19000101') AND FORMAPAGO='E'");
            totalCaja += Convert.ToDouble(dt.Rows[0][0].ToString());

            //CAJA INICIAL
            dt = new DataTable();
            con.Execute(ref dt, "SELECT ISNULL(SUM(CAST(ISNULL(B20,0) AS FLOAT)+CAST(ISNULL(B50,0) AS FLOAT)+CAST(ISNULL(B100,0) AS FLOAT)+CAST(ISNULL(B200,0) AS FLOAT)+CAST(ISNULL(B500,0) AS FLOAT)+CAST(ISNULL(B1000,0) AS FLOAT)+CAST(ISNULL(M10CEN,0) AS FLOAT)+CAST(ISNULL(M20CEN,0) AS FLOAT)+CAST(ISNULL(M50CEN,0) AS FLOAT)+CAST(ISNULL(M1PES,0) AS FLOAT)+CAST(ISNULL(M2PES,0) AS FLOAT)+CAST(ISNULL(M5PES,0) AS FLOAT)+CAST(ISNULL(M10PES,0) AS FLOAT)+CAST(ISNULL(M20PES,0) AS FLOAT)),0) FROM Caja WHERE RTRIM(LTRIM(Status))='ABIERTA' AND ISNULL(FechaFIn,'19000101')='19000101'");
            totalCaja += Convert.ToDouble(dt.Rows[0][0].ToString());

            //RETIRO DE CAJA
            dt = new DataTable();
            con.Execute(ref dt, "SELECT ISNULL(SUM(Importe),0) FROM Retiro WHERE RTRIM(LTRIM(CorteParcial))=(SELECT TOP 1 CVE FROM Caja WHERE RTRIM(LTRIM(Status))='ABIERTA' AND ISNULL(FechaFIn,'19000101')='19000101')");
            totalCaja -= Convert.ToDouble(dt.Rows[0][0].ToString());

            //ABONOS DE CTES
            dt = new DataTable();
            con.Execute(ref dt, "SELECT ISNULL(SUM(ImporteAbono),0) FROM AbonosClientes WHERE RTRIM(LTRIM(CorteParcial))=(SELECT TOP 1 CVE FROM Caja WHERE RTRIM(LTRIM(Status))='ABIERTA' AND ISNULL(FechaFIn,'19000101')='19000101') AND status='A' and formapago='E'");
            totalCaja += Convert.ToDouble(dt.Rows[0][0].ToString().Trim());

            //COMPRAS (disminuye caja)
            dt = new DataTable();
            con.Execute(ref dt, "SELECT ISNULL(SUM(COSTOUNIT),0) FROM EntradasInventario WHERE RTRIM(LTRIM(CorteParcial))=(SELECT TOP 1 CVE FROM Caja WHERE RTRIM(LTRIM(Status))='ABIERTA' AND ISNULL(FechaFIn,'19000101')='19000101') AND tipo='E' and afectarcaja=1");
            totalCaja -= Convert.ToDouble(dt.Rows[0][0].ToString().Trim());

            //ABONOS DE PROVEEDORES
            //dt = new DataTable();
            //con.Execute(ref dt, "SELECT ISNULL(SUM(ImporteAbono),0) FROM Abonosproveedores WHERE RTRIM(LTRIM(CorteParcial))=(SELECT TOP 1 CVE FROM Caja WHERE RTRIM(LTRIM(Status))='ABIERTA' AND ISNULL(FechaFIn,'19000101')='19000101') AND status='A' and formapago='E'");
            //totalCaja -= Convert.ToDouble(dt.Rows[0][0].ToString().Trim());

            return totalCaja;

        }



        public string LeeArchivoConexion(string archivo)
        {
            int CONT = 0; 
            string connectionStringSQL = "", IP = "", DB = "", USER = "", PASS = "";

            try
            {
                using (StreamReader sr = new StreamReader(archivo))
                {
                    String linea;
                    CONT = 0;
                    while ((linea = sr.ReadLine()) != null)
                    {
                        CONT += 1;
                        switch (CONT)
                        {
                            case 1:
                                IP = linea;
                                break;
                            case 2:
                                DB = linea;
                                break;
                            case 3:
                                USER = linea;
                                break;
                            case 4:
                                PASS = linea;
                                break;
                        }
                    }
                    sr.Close();
                }

                USER = "prueba";
                PASS = "prueba";

                //connectionStringSQL = "Data Source=" + IP + ";Initial Catalog=" + DB + ";User ID=" + USER + ";Password=" + PASS;
                connectionStringSQL = "Data Source=" + IP + ";Initial Catalog=" + DB + ";User ID=" + USER + ";Password=" + PASS;
                return connectionStringSQL;
            }
            catch (Exception Ex)
            {
                System.Windows.Forms.MessageBox.Show(Ex.Message, "ERROR", System.Windows.Forms.MessageBoxButtons.OK, System.Windows.Forms.MessageBoxIcon.Error);
                return connectionStringSQL;
            }
        }

        public bool buscaFamilia(string familia)
        {
            ConexionEladio con = new ConexionEladio();

            bool resp = false;

            DataTable dtFami = new DataTable();
            con.Execute(ref dtFami, "select * from catfamilias where nombrefamilia='" + familia.Trim().ToUpper() + "'");

            if (dtFami.Rows.Count > 0)
                resp = true;

            return resp;

        }

        public void agregaFamilia(string familia)
        {
            ConexionEladio con = new ConexionEladio();

            DataTable dtFami = new DataTable();
            con.Execute(ref dtFami, "select * from catfamilias where nombrefamilia='" + familia.Trim().ToUpper() + "'");

            if (dtFami.Rows.Count == 0)
            {
                con.Execute("insert into catfamilias(nombrefamilia) values ('" + familia.Trim().ToUpper() + "')");
            }

        }

        public void agregasubFamilia(string subfamilia)
        {
            ConexionEladio con = new ConexionEladio();

            DataTable dtFami = new DataTable();
            con.Execute(ref dtFami, "select * from catsubfamilias where nombresubfamilia='" + subfamilia.Trim().ToUpper() + "'");

            if (dtFami.Rows.Count == 0)
            {
                con.Execute("insert into catsubfamilias(nombresubfamilia) values ('" + subfamilia.Trim().ToUpper() + "')");
            }

        }

        public bool buscaSubFamilia(string subfamilia)
        {
            ConexionEladio con = new ConexionEladio();

            bool resp = false;

            DataTable dtFami = new DataTable();
            con.Execute(ref dtFami, "select * from catsubfamilias where nombresubfamilia='" + subfamilia.Trim().ToUpper() + "'");

            if (dtFami.Rows.Count > 0)
                resp = true;

            return resp;

        }

        public string OpenDialogo()
        {
            //First, declare a variable to hold the user’s file selection.

            string resp="-1";
            String input = string.Empty;

            //Create a new instance of the OpenFileDialog because it's an object.
            System.Windows.Forms.OpenFileDialog dialog = new System.Windows.Forms.OpenFileDialog();
            dialog.Filter = "Excel |*.xls";

            //Set the starting directory and the title.

            dialog.InitialDirectory = "C:"; 
            dialog.Title = "Selecciona un archivo";


            if (dialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                 resp = dialog.FileName;

            if (resp == String.Empty)
                return "-1"   ;  //usuario no selecciono archivo

            return resp;
        
        }

    } 
}
