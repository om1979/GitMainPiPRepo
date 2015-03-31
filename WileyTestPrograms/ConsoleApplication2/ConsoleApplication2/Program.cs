using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.IO;
using System.ServiceModel.Web;
using System.Threading;
using System.Diagnostics;



namespace ConsoleApplication2
{
    class Program
    {
        static void Main(string[] args)
        {


                ConsoleKeyInfo RealLine;
                Stopwatch stopwatch = new Stopwatch(); 
                
            stopwatch.Start();



            string abc = RealLine.GetType().ToString();

            //while ( stopwatch.ElapsedMilliseconds < 100)
            //{
            //    RealLine.Key.ToString() 
            //   // RealLine = Console.ReadKey();
            //   // if (cki.Key == ConsoleKey.Escape)
            //        //Console.WriteLine("no sali!!");
            //        break;
            //}
            //    Console.WriteLine("ya me sali");
           


           // if Console.ReadKey

            //HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            //request.Method = "POST";
            //request.ContentType = "application/json; charset=utf-8";
            //System.ServiceModel.Web.
            //DataContractJsonSerializer ser = new DataContractJsonSerializer(data.GetType());
            //MemoryStream ms = new MemoryStream();
            //ser.WriteObject(ms, data);
            //String json = Encoding.UTF8.GetString(ms.ToArray());
            //StreamWriter writer = new StreamWriter(request.GetRequestStream());
            //writer.Write(json);
            //writer.Close();



        }
    }
}
