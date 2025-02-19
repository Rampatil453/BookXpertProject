using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data.SqlClient;
using System.Configuration;
using System.Web.WebSockets;
using System.Data;
namespace BookXpertProject
{
   
    public partial class EmployeeDetails : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataReader dr;
        string str = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindEmployee();
            }
        }
        public void BindEmployee()
        {
            try
            {
                con = new SqlConnection(str);
                con.Open();
                cmd = new SqlCommand("select * from Employees", con);
                dr = cmd.ExecuteReader();
                gvEmployees.DataSource = dr;
                gvEmployees.DataBind();
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                con.Close();
            }
           
           

        }
        void ClearForm()
        {
            hdnId.Value = "0"; 
            txtName.Text = "";
            txtDesignation.Text = "";
            txtDOJ.Text = "";
            txtSalary.Text = "";
            rdoMale.Checked = false;
            rdoFemale.Checked = false;
            ddlState.SelectedIndex = 0;
            btnSave.Text = "Save";
        }

     

     

       

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;

            string id = btn.CommandArgument;

            int recordId = Convert.ToInt32(id);
            con = new SqlConnection(str);
            con.Open();
            cmd = new SqlCommand("sp_ManageEmployee", con);
            cmd.Parameters.AddWithValue("@Action", "DELETE");
            cmd.Parameters.AddWithValue("@Id", recordId);
            cmd.CommandType = CommandType.StoredProcedure;
            int i = cmd.ExecuteNonQuery();
            if (i == -1)
            {
              

                // Show JavaScript alert
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Transaction deleted successfully!');", true);
            }
            BindEmployee();
        }

        protected void lnkSelect_Click(object sender, EventArgs e)
        {

            LinkButton lnkselect = (LinkButton) sender;
            int employeeId = Convert.ToInt32(lnkselect.CommandArgument);
            try
            {
                con = new SqlConnection(str);
                con.Open();
                cmd = new SqlCommand("select * from Employees where Id=@Id", con);
                cmd.Parameters.AddWithValue("@Id", employeeId);
                dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtName.Text = dr["Name"].ToString();
                    txtDesignation.Text = dr["Designation"].ToString();
                    txtDOJ.Text = Convert.ToDateTime(dr["Doj"]).ToString("yyyy-MM-dd");
                    txtSalary.Text = dr["Salary"].ToString();
                    string gender = dr["Gender"].ToString();
                    if(gender == "M")
                    {
                        rdoMale.Checked = true;
                    }
                    else
                    {
                        rdoFemale.Checked = true;
                    }
                    ddlState.SelectedValue = dr["State"].ToString();
                    
                    btnSave.Text = "Update";
                    hdnId.Value = employeeId.ToString();
                }
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                con.Close();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            
            int EmployeeId = Convert.ToInt32(hdnId.Value);
            try
            {
                   
                con = new SqlConnection(str);
                con.Open();
                cmd = new SqlCommand("sp_ManageEmployee", con);

                cmd.Parameters.AddWithValue("@Action", EmployeeId == 0 ? "INSERT" : "UPDATE");
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@Designation",txtDesignation.Text.Trim());
                cmd.Parameters.AddWithValue("@DOJ", Convert.ToDateTime(txtDOJ.Text));
                cmd.Parameters.AddWithValue("@Salary", Convert.ToDecimal(txtSalary.Text));               
                cmd.Parameters.AddWithValue("@Id", (EmployeeId));
                
                string gender = rdoMale.Checked ? "M" : (rdoFemale.Checked ? "F" : "");
                cmd.Parameters.AddWithValue("@Gender", gender);

                cmd.Parameters.AddWithValue("@State", ddlState.SelectedValue);
                cmd.CommandType = CommandType.StoredProcedure;
                 int i=cmd.ExecuteNonQuery();
                if (i == -1)
                {
                   
                    if (EmployeeId == 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Transaction Insert successfully!');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Transaction Update successfully!');", true);

                    }


                }
                ClearForm();
                BindEmployee();
            }
            catch(Exception ex)
            {

            }
            finally
            { 
                con.Close();
            }

        }

        protected void btnNew_Click(object sender, EventArgs e)
        {
            ClearForm();
        }
    }
}