<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SideBar.ascx.cs" Inherits="groupware2.View.Controls.SideBar" %>

<div class="sidebar">
    <ul class="form-label">
        <li><asp:HyperLink ID="hlList" runat="server" Text="그룹게시판"/></li>
        <li><asp:HyperLink ID="hlGPT" runat="server" Text="GPT게시판" NavigateUrl="~/View/GPTForm.aspx"/></li>
    </ul>
</div>