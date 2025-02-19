<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeDetails.aspx.cs" Inherits="BookXpertProject.EmployeeDetails" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Details</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            $("#<%= btnSave.ClientID %>").click(function () {
                let isValid = true;
                $(".validate").each(function () {
                    if ($(this).val().trim() === "") {
                        isValid = false;
                        alert("Please fill all fields.");
                        return false;
                    }
                });
                if (!isValid) return false;
            });
        });

        $(document).ready(function () {
            function calculateTotalSalary() {
                var totalSalary = 0;
                $(".salaryCell").each(function () {
                    var salary = parseFloat($(this).text()) || 0;
                    totalSalary += salary;
                });
                $("#totalSalary").text(totalSalary.toFixed(2));
            }
            calculateTotalSalary();
        });
    </script>
    <style type="text/css">
        .auto-style1 {
            position: absolute;
            top: 174px;
            left: 507px;
            right: 482px;
            z-index: 1;
        }
    </style>
</head>
<body>
    
    <form id="form1" runat="server">
       
        <div>
            <h2>Employee Details</h2>
                <table border="1" cellpadding="5" cellspacing="0" style="border-collapse: collapse; width: 30%;">
                    <tr>
                        <td><label>Name:</label></td>
                        <td><asp:TextBox ID="txtName" runat="server" CssClass="validate"></asp:TextBox></td>
                    </tr>
    
                    <tr>
                        <td><label>Designation:</label></td>
                        <td><asp:TextBox ID="txtDesignation" runat="server" CssClass="validate"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <td><label>Date of Join:</label></td>
                        <td><asp:TextBox ID="txtDOJ" runat="server" CssClass="validate" TextMode="Date"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <td><label>Salary:</label></td>
                        <td><asp:TextBox ID="txtSalary" runat="server" CssClass="validate" TextMode="Number"></asp:TextBox>
                            <asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="txtSalary" CssClass="auto-style1" ErrorMessage="Salary should be grater than 100 and less than 10,00,000" ForeColor="Red" MaximumValue="1000000" MinimumValue="100" SetFocusOnError="True"></asp:RangeValidator>
                        </td>
                    </tr>

                    <tr>
                        <td><label>Gender:</label></td>
                        <td>
                            <asp:RadioButton ID="rdoMale" runat="server" GroupName="gender" Text="Male" />
                            <asp:RadioButton ID="rdoFemale" runat="server" GroupName="gender" Text="Female" />
                        </td>
                    </tr>

                    <tr>
                        <td><label>State:</label></td>
                        <td>
                            <asp:DropDownList ID="ddlState" runat="server">
                                <asp:ListItem Text="--Select State--" Value="Select State"></asp:ListItem>
                                <asp:ListItem Text="Telangana" Value="Telangana"></asp:ListItem>
                                <asp:ListItem Text="Andhra Pradesh" Value="Andhra Pradesh" />
                                <asp:ListItem Text="Maharashtra" Value="Maharashtra" />
                                <asp:ListItem Text="Karnataka" Value="Karnataka" />
                                <asp:ListItem Text="Rajasthan" Value="Rajasthan" />
                                <asp:ListItem Text="Uttar Pradesh" Value="Uttar Pradesh" />
                                <asp:ListItem Text="Delhi" Value="Delhi" />
                            </asp:DropDownList>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2" align="center">
                            <asp:HiddenField ID="hdnId" runat="server" Value="0" />
                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn" OnClick="btnSave_Click"/>
                            <asp:Button ID="btnNew" runat="server" Text="New Employee" CssClass="btn" OnClick="btnNew_Click"/>
                        </td>
                    </tr>
                </table>

            <h3>List of Employees</h3>
           <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None">
            <AlternatingRowStyle BackColor="White" />
              <Columns>
                <asp:TemplateField HeaderText="S.No">
                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Name">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkSelect" runat="server" Text='<%# Eval("Name") %>' CommandArgument='<%# Eval("Id") %>' OnClick="lnkSelect_Click"/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Designation">
                    <ItemTemplate>
                        <span class="designation"><%# Eval("Designation") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="DOJ">
                    <ItemTemplate>
                        <span class="doj"><%# Eval("DOJ", "{0:dd/MM/yyyy}") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Salary">
                    <ItemTemplate>
                        <span class="salaryCell"><%# Eval("Salary") %></span> 
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Gender">
                    <ItemTemplate>
                        <span class="gender"><%# Eval("Gender") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="State">
                    <ItemTemplate>
                        <span class="state"><%# Eval("State") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" Text="DELETE" CommandArgument='<%# Eval("Id") %>' OnClick="btnDelete_Click"/>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
               <EditRowStyle BackColor="#2461BF" />
               <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
               <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
               <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
               <RowStyle BackColor="#EFF3FB" />
               <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
               <SortedAscendingCellStyle BackColor="#F5F7FB" />
               <SortedAscendingHeaderStyle BackColor="#6D95E1" />
               <SortedDescendingCellStyle BackColor="#E9EBEF" />
               <SortedDescendingHeaderStyle BackColor="#4870BE" />
        </asp:GridView>

        <h3>Total Salary: <span id="totalSalary">0</span></h3>
        </div>
    </form>
    <asp:Label ID="lblmsg" runat="server" Visible="false"></asp:Label>
</body>
</html>
