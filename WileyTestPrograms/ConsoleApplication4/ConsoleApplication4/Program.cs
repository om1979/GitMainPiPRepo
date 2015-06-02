using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication4
{


    class  Rectangle
    {
        private double length;
        private double width;
        
        public  Rectangle(double l, double w) 
        {
            
            length = l;
            width = w;
        
        }
        public double GetArea()
        {

            return length * width; 
        }

    }
    class Program
    {
        static void Main(string[] args)
        {
            //Console.WriteLine("Ingresa Altura");
            //double h = Convert.ToDouble(Console.ReadLine());
            //Console.WriteLine("Ingresa Ancho");
            //double w=Convert.ToDouble(Console.ReadLine());

            //Console.WriteLine("Area de Rectangulo =");
             //Rectangle axxx =  new  Rectangle(h, w);
             //Console.WriteLine(axxx.GetArea());
        
            Rectangle rect = new Rectangle(10.0, 20.0);
            double area = rect.GetArea();
            Console.WriteLine("Area of Rectangle: {0}",area);
            
            Console.ReadLine();
        }
    }
}
