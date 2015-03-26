using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ConsoleApplication1.net.webservicex;


namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            net.webservicex.www.CurrencyConvertor Convertor = new net.webservicex.www.CurrencyConvertor();

                double new_data = Convertor.ConversionRate(net.webservicex.www.Currency.ALL, net.webservicex.www.Currency.ARS);
                    Console.WriteLine(new_data);
                    Console.ReadLine();
        }
    }
}
