<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NavBar.ascx.cs" Inherits="groupware2.View.Controls.NavBar" %>

<nav class="navbar navbar-expand-lg">
  <div class="container-fluid" style="max-width:1240px;">
    
      <asp:HyperLink ID="hlList" runat="server">
          <asp:Image ID="Logo" runat="server" ImageUrl="~/Content/Images/logo.jpg" CssClass="logo"/>
      </asp:HyperLink>
      
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" style="" id="navbarSupportedContent">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0 form-label">
        <li class="nav-item text-bold">
            <a class="nav-link active" aria-current="page" href="#">메일</a>
        </li>
        <li class="nav-item text-bold">
            <a class="nav-link active" aria-current="page" href="#">전자결재</a>
        </li>
        <li class="nav-item text-bold">
            <a class="nav-link active" aria-current="page" href="#">게시판</a>
        </li>
        <li class="nav-item text-bold">
            <a class="nav-link active" aria-current="page" runat="server" href="~/View/GPTForm.aspx">GPT</a>
        </li>
        </ul>
        <form class="d-flex me-3">
            <input class="form-control me-2 my-auto" type="search" placeholder="통합 검색" aria-label="Search">
            <button class="sky-btn" style="width:80px; height:38px;" type="submit">검색</button>
        </form>
        <asp:HyperLink ID="loginlbtn" runat="server" Text="Login" CssClass="me-2 text-darkblue" NavigateUrl="~/View/AdminForm.aspx" />
        <asp:HyperLink ID="logoutlbtn" runat="server" Text="Logout" CssClass="me-2 text-darkblue" NavigateUrl="~/Handlers/LogoutHandler.aspx" />
    </div>
  </div>
</nav>