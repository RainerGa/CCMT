using System;
using System.Windows.Forms;

namespace WinFormsApp1
{
    public partial class UCClient : Form
    {
        public UCClient()
        {
            InitializeComponent();
            // Disable resize
            FormBorderStyle = FormBorderStyle.FixedSingle;
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (label4.Text == "Incomming Call")
            {
                label4.Text = "Active Call with:";
                label5.Text = "1234/123 456 7";
                return;
            }

            if (label4.Text == "Active Call with:")
            {
                label4.Text = "Incomming Call";
                label5.Text = "Name, Surname";
                return;
            }

        }
    }
}
