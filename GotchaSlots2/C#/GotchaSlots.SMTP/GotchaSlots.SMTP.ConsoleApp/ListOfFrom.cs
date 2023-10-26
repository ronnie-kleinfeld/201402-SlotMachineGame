using System;
using System.Collections.Generic;
using System.Text;

namespace GotchaSlots.SMTP.ConsoleApp
{
    public class ListOfFrom : BaseAction
    {
        public void List()
        {
            Console.WriteLine("List starting");

            int count;
            foreach (SMTPFromDataSet.T_FROMRow drFrom in _smtpFrom.T_FROM.Rows)
            {
                count = 0;
                foreach (SMTPFromDataSet.T_FROM_SENTRow drFromSent in _smtpFrom.T_FROM_SENT.Rows)
                {
                    try
                    {
                        if (drFromSent.SNT_FROM_EMAIL == drFrom.EMF_EMAIL)
                        {
                            count += drFromSent.SNT_COUNT;
                        }
                    }
                    catch (Exception ex)
                    {
                    }
                }
                Console.WriteLine("From {0} {1} {2} {3} {4}", count, drFrom.EMF_RECENT_DATETIME.ToLocalTime(), drFrom.EMF_SMTP, drFrom.EMF_DESCRIPTION, drFrom.EMF_EMAIL);
            }

            count = 0;
            foreach (SMTPFromDataSet.T_FROM_SENTRow drFromSent in _smtpFrom.T_FROM_SENT.Rows)
            {
                try
                {
                    count += drFromSent.SNT_COUNT;
                }
                catch (Exception ex)
                {
                }
            }
            Console.WriteLine("Count of sent EMails {0}", count);

            Console.WriteLine("List finished");
        }
    }
}