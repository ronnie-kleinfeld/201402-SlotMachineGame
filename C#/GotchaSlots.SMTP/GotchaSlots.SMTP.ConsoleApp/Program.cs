using System;
using System.Collections.Generic;
using System.Text;

namespace GotchaSlots.SMTP.ConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("MailSender");
            Console.WriteLine("");
            Console.WriteLine("1. List of From");
            Console.WriteLine("2. Send EMails");
            Console.WriteLine("3. Create SMTPTo.xml");
            Console.WriteLine("");
            Console.WriteLine("");
            string input = Console.ReadLine();

            switch (input)
            {
                case "1":
                    Console.WriteLine("List of From");
                    ListOfFrom listOfFrom = new ListOfFrom();
                    listOfFrom.List();
                    break;
                case "2":
                    Console.WriteLine("Send EMails");
                    SendEMails sendEMails = new SendEMails();
                    sendEMails.Send();
                    break;
                case "3":
                    Console.WriteLine("Create SMTPTo.xml");
                    CreateSMTPToXml createSMTPToXml = new CreateSMTPToXml();
                    createSMTPToXml.Create();
                    break;
                default:
                    Console.WriteLine("Input out of range");
                    break;
            }
            Console.ReadLine();
        }
    }
}
