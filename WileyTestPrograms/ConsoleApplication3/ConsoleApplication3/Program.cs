using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections;
using System.Reflection;
using System.Dynamic;
using Newtonsoft.Json;


namespace ConsoleApplication3
{
    class Program
    {
        static void Main(string[] args)
        {
            // clase que imprime Mensajer Definidos por el Progrmador
            linePrinter Printer = new linePrinter();
            //Clase de WB para extraccion de precios
            WSReuters.ConsultaPreciosWSClient WSConsultaPrecios = new WSReuters.ConsultaPreciosWSClient();
            //Lista de tipo Objeto Como resultado final de Extraccion
            List<ObjtWSReutersData> ObjectFinakWsData = new List<ObjtWSReutersData>();
            List<ObjtWSReutersData> ObjectFinakWsDataFINAL = new List<ObjtWSReutersData>();
            //Diccionario para guardar los items y sus valores por Ric (Dinamico)

            

            /*
            Inicia Porceso de Extraccion desde WBReuters
            */
            Printer.MainTitle();


        

            try {
            Printer.IniciaExtraccion();
            /*
             Interamos el corte de obtenerPrecios y recorremos todos sus campos
             */
            foreach (WSReuters.campos campos in WSConsultaPrecios.obtenerPrecios())
           {
               Console.WriteLine("Obteniendo Informacion de Ric::{0}", campos.RIC.ToString());
                ConsoleApplication3.ObjtWSReutersData Temp_ObjectWsData = new ConsoleApplication3.ObjtWSReutersData();
                Temp_ObjectWsData.txtIRC = campos.RIC.ToString();

                /*
                 Dentro de cada campo obtenemos los los items y sus valores por cada Ric
                 */
                ArrayList DicWSDataFLD = new ArrayList();
                ArrayList DicWSDataVal = new ArrayList();
               foreach (WSReuters.campo campoWs in campos.FLD)
               {
                   object txtFLD = campoWs.FLD.ToString();
                   object txtFLDVal = campoWs.VAL.ToString();

                   DicWSDataFLD.Add(txtFLD);
                   DicWSDataVal.Add(txtFLDVal);
                   Temp_ObjectWsData.txtFLD = DicWSDataFLD;
                   Temp_ObjectWsData.txtFLDVal = DicWSDataVal;

               }
                /*
                 Agregamos lo obtenido del Ric a Objeto Final para seguir interando
                 * Limpiamos Diccionarios y objeto TEmporal
                 */
               ObjectFinakWsData.Add(Temp_ObjectWsData);
               Temp_ObjectWsData = null;

           }

            }
            catch (Exception e)
            {
                Console.WriteLine("Error al Establecer la conexion con el WS Elektron");
                Console.WriteLine(e.Message);
                System.Threading.Thread.Sleep(4000);
                Environment.Exit(0);
            }



            //FIN DE CICLOS 
             /*
             Reportamos termino del programa
             */

            //System.Threading.Thread.Sleep(5000);
            //Console.Clear();
            //Printer.MainTitle();
            Console.WriteLine("Extraccion Finalizada Se Procesaron {0} Rics ", ObjectFinakWsData.Count().ToString());
            //Console.WriteLine("Presione una tecla para terminar...");
            //Console.ReadLine();

            /*Ejecutamos proceso para trabajar con Informacion conseguida*/

            string json = JsonConvert.SerializeObject(ObjectFinakWsData[1]);

            //string acdaa = WSConsultaPrecios.RequestedRics(json,1);
            ObjtWSReutersData NewElement = new ObjtWSReutersData();

            //String Responce = WSConsultaPrecios.RequestedRics(json);
             
            
             // NewElement.Equals(WSConsultaPrecios.RequestedRics(json));


               //NewElement.txtFLD[0].ToString();
              NewElement.txtFLD.AddRange(WSConsultaPrecios.RequestedRics(json).txtFLD);

              WSConsultaPrecios.RequestedRics(json);



            ProcessInfo(ObjectFinakWsData);
        }

        static void ProcessInfo(List<ObjtWSReutersData> ObjectFinakWsData)
        {

            foreach (ObjtWSReutersData adc in ObjectFinakWsData)
            {
                Console.WriteLine("------");
                Console.WriteLine(adc.txtIRC);
                Console.WriteLine("------");

                int x = 0;
                foreach (string ACD in adc.txtFLD)
                {
                    Console.WriteLine(ACD + ":: " + adc.txtFLDVal[x].ToString());
                    //Console.Write(adc.txtFLDVal[x].ToString());
                    x = x+1;  
                }
            }
            Console.ReadLine();
        }



    }
         
}
