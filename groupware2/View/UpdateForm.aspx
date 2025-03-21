<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="UpdateForm.aspx.cs" Inherits="groupware2.UpdateForm" %>

<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <form id="form1" runat="server">
        <div class="container">
            <div class="post-form">
                <h3 class="text-bold">게시글 수정</h3>
                <!-- 제목 입력 -->
                <asp:Label ID="lblTitle" runat="server" Text="제목" CssClass="form-label" />
                <asp:TextBox ID="txtTitle" runat="server" Width="100%" CssClass="form-control"/>

                <!-- 내용 입력 -->
                <asp:Label ID="lblContent" runat="server" Text="내용" CssClass="form-label" />
                <div class="editor-container editor-container_document-editor editor-container_include-style" id="editor-container">
                    <div class="editor-container__menu-bar" id="editor-menu-bar"></div>
                    <div class="editor-container__toolbar" id="editor-toolbar"></div>
                    <div class="editor-container__editor-wrapper">
                        <div class="editor-container__editor"><div id="editor"></div></div>
                    </div>
                 </div>
                <asp:HiddenField ID="hiddenContent" runat="server" />

                <!-- 개인정보 입력 -->
                <div class="row-list">
                    <div class="col-half">
                        <asp:Label ID="lblAuthorName" runat="server" Text="작성자 이름" CssClass="form-label" />
                        <asp:TextBox ID="txtAuthorName" runat="server" CssClass="form-control" Enabled="false" />
                    </div>
                    <div class="col-half">
                        <asp:Label ID="lblAuthorPassword" runat="server" Text="비밀번호" CssClass="form-label" />
                        <asp:TextBox ID="txtAuthorPassword" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                </div>

                <!-- 관리자 수정 사유 -->
                <asp:Panel ID="pnlAdminOptions" runat="server" Visible="false">
                    <asp:Label ID="lblEditReason" runat="server" Text="수정 사유 선택" CssClass="form-label" />
                    <asp:DropDownList ID="ddlEditReason" runat="server" CssClass="form-control">
                        <asp:ListItem Text="부적절한 표현 수정" Value="InappropriateContent"></asp:ListItem>
                        <asp:ListItem Text="개인정보 보호" Value="PersonalInfoExposed"></asp:ListItem>
                        <asp:ListItem Text="허위 정보 수정" Value="Misinformation"></asp:ListItem>
                        <asp:ListItem Text="잘못된 카테고리 이동" Value="WrongCategory"></asp:ListItem>
                        <asp:ListItem Text="광고/스팸 수정" Value="SpamOrAdvertisement"></asp:ListItem>
                        <asp:ListItem Text="가독성 향상" Value="ReadabilityImprovement"></asp:ListItem>
                    </asp:DropDownList>
                </asp:Panel>
                
                <asp:CheckBox ID="hasEditor" runat="server" Text="협업 에디터 활성화" CssClass="custom-checkbox"/>
                
                <!-- 버튼 -->
                <div class="row-list">
                    <asp:Button ID="btnUpdate" runat="server" Text="수정" OnClick="BtnUpdate_Click" CssClass="sky-btn"/>
                    <asp:HyperLink ID="hlList" runat="server" Text="목록" CssClass="gray-btn"/>
                </div>
            </div>
        </div>
    </form>

    <!-- CKEditor -->
    <script src="https://cdn.ckeditor.com/ckeditor5/44.1.0/ckeditor5.umd.js" crossorigin="anonymous"></script>
    <script src="https://cdn.ckeditor.com/ckeditor5/44.1.0/translations/ko.umd.js" crossorigin="anonymous"></script>
    <script src="<%= ResolveUrl("~/Scripts/editor.js") %>"></script>
    <script type="text/javascript">
        document.getElementById('<%= txtAuthorPassword.ClientID %>').setAttribute('required', 'required');

        DecoupledEditor.create(document.querySelector('#editor'), editorConfig).then(editor => {
            document.querySelector('#editor-toolbar').appendChild(editor.ui.view.toolbar.element);
            document.querySelector('#editor-menu-bar').appendChild(editor.ui.view.menuBarView.element);
        });

        document.getElementById('Content_btnUpdate').addEventListener('click', function () {
            var editorHtml = document.getElementById('editor').innerHTML;
            document.getElementById('<%= hiddenContent.ClientID %>').value = encodeURIComponent(editorHtml);
        });
    </script>
</asp:Content>
