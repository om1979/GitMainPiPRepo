using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace ConsoleApplication3
{
    class linePrinter
    {

        public void MainTitle()
        {

            string RLine = new string('-', 46);

            Console.WriteLine(" " + RLine);
            Console.WriteLine("|    Proveedor Integral de Precios             |");
            Console.WriteLine("|    Sistema de Respaldo para Bases de Datos   |");
            Console.WriteLine("|    V:1.0001                                  |");
            Console.WriteLine(" " + RLine);
        }


        public void IniciaExtraccion()
        {
          Console.WriteLine("Extraccion en Progreso...");
        }


    }
}
