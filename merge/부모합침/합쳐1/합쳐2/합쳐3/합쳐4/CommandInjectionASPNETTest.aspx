<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CommandInjectionASPNETTest.cs" Inherits="MyVulnerableWebsite.CommandInjection" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form id="form1" runat="server">
    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
    <asp:TextBox ID="MessageTextBox" runat="server"></asp:TextBox>
    <div>

    </div>
</form>
</body>
</html>
