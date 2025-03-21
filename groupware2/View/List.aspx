<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="groupware2.List" %>

<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <form id="form1" runat="server">
        <div class="container">
            <div class="my-2" style="display: flex; justify-content: space-between; align-items:center;">
                <h3 class="text-bold">그룹게시판</h3>
                <button type="button" class="gray-btn" style="height:40px;" onclick="location.href='WriteForm.aspx';">
                    글쓰기
                </button>
            </div>

            <!-- 게시글 목록 -->
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CssClass="gridview">
                <Columns>
                    <asp:TemplateField HeaderText="번호" SortExpression="Id">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("Id") %>'/>
                        </ItemTemplate>
                        <ItemStyle Width="100px" CssClass="form-label"/>
                        <HeaderStyle Width="100px"  CssClass="form-label"/>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="제목" SortExpression="Title">
                        <ItemTemplate>
                            <asp:HyperLink
                                runat="server" 
                                NavigateUrl='<%# "Detail.aspx?Id=" + Eval("Id") %>'
                                Text='<%# Eval("Title") %>'
                                CssClass="text-black"/>
                        </ItemTemplate>
                        <ItemStyle CssClass="form-label"/>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="작성자" SortExpression="AuthorName">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("AuthorName") %>'/>
                        </ItemTemplate>
                        <ItemStyle Width="100px" CssClass="form-label"/>
                        <HeaderStyle Width="100px" CssClass="form-label"/>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="작성일" SortExpression="CreatedAt">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("CreatedAt", "{0:yyyy-MM-dd}") %>'/>
                        </ItemTemplate>
                        <ItemStyle Width="150px" CssClass="form-label"/>
                        <HeaderStyle Width="150px" CssClass="form-label"/>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="조회수" SortExpression="Views">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("Views") %>'/>
                        </ItemTemplate>
                        <ItemStyle Width="70px" CssClass="form-label"/>
                        <HeaderStyle Width="70px" CssClass="form-label"/>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <!-- 페이지 네비게이션 바 -->
            <div class="pagination">
                <asp:Button ID="BtnPrevious" runat="server" Text="이전" OnClick="BtnPrevious_Click" />

                <div class="page-numbers" id ="pageNumbers" runat="server">
           
                </div>

                <asp:Button ID="BtnNext" runat="server" Text="다음" OnClick="BtnNext_Click" />
            </div>
        </div>
    </form>
</asp:Content>
