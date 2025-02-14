<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="AdminList.aspx.cs" Inherits="groupware2.AdminList" %>

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

                    <asp:TemplateField HeaderText="삭제여부" SortExpression="IsRemove">
                        <ItemTemplate>
                            <asp:Label ID="lblIsRemove" runat="server" 
                                Text='<%# Eval("IsRemove").ToString() == "True" ? "Y" : "N" %>' 
                                CssClass='<%# Eval("IsRemove").ToString() == "True" ? "text-red" : "text-blue" %>'
                                >
                            </asp:Label>
                        </ItemTemplate>
                        <ItemStyle Width="100px" CssClass="form-label"/>
                        <HeaderStyle Width="100px" CssClass="form-label"/>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="관리" SortExpression="Management">
                        <ItemTemplate>
                            <asp:HyperLink ID="btnEdit" runat="server" Text="수정" CssClass="gray-btn" NavigateUrl=<%# "UpdateForm.aspx?Id="+ Eval("Id") %>
                                CommandName="Edit" Visible='<%# !(bool)Eval("IsRemove") %>' />

                            <asp:HyperLink ID="btnRestore" runat="server" Text="복원" CssClass="sky-btn" NavigateUrl=<%# "PasswordForm.aspx?mode=restore&Id="+Eval("Id") %>
                                CommandName="Restore" Visible='<%# (bool)Eval("IsRemove") %>' />

                            <asp:HyperLink ID="btnDelete" runat="server" Text="삭제" CssClass="red-btn" NavigateUrl=<%# "PasswordForm.aspx?mode=delete&Id="+Eval("Id") %> 
                                CommandName="Delete" />
                        </ItemTemplate>
                        <ItemStyle Width="150px" CssClass="admin-functions"/>
                        <HeaderStyle Width="150px" CssClass="form-label"/>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <!-- 페이징 -->
            <div class="pagination">
                <asp:Button ID="BtnPrevious" runat="server" Text="이전" OnClick="BtnPrevious_Click" />

                <div class="page-numbers" id ="pageNumbers" runat="server">
           
                </div>

                <asp:Button ID="BtnNext" runat="server" Text="다음" OnClick="BtnNext_Click" />
            </div>
        </div>
    </form>
    <script>
    </script>
</asp:Content>
