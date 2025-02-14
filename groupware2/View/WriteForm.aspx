<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="WriteForm.aspx.cs" Inherits="groupware2.WriteForm" %>

<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <form id="form1" runat="server">
        <div class="container">
            <div class="post-form">
                <h3 class="text-bold">새 게시글 작성</h3>

                <!-- 제목 입력 -->
                <asp:Label ID="lblTitle" runat="server" Text="제목" CssClass="form-label" />
                <asp:TextBox ID="txtTitle" runat="server" Width="100%" CssClass="form-control" />

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
                    <div class="row-list col-half" style="gap:5px;">
                        <div class="col-half">
                            <asp:Label ID="lblAuthorName" runat="server" Text="작성자 이름" CssClass="form-label" />
                            <asp:TextBox ID="txtAuthorName" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-half">
                            <asp:Label ID="lblAuthorPassword" runat="server" Text="비밀번호" CssClass="form-label" />
                            <asp:TextBox ID="txtAuthorPassword" runat="server" CssClass="form-control" TextMode="Password" />
                        </div>
                    </div>
                    <div class="col-half">
                        <asp:Label ID="lblAuthorEmail" runat="server" Text="이메일" CssClass="form-label" />
                        <div class="row-list mb-2" style="gap:3px; flex-wrap:nowrap;">
                            <div style="width:52%;">
                                <asp:TextBox ID="txtAuthorEmailID" runat="server" CssClass="form-control" />
                            </div>
                            <div class="text-center form-label" style="font-size:20px; line-height:35px;">
                                @
                            </div>
                            <div style="width:40%;">
                                <asp:DropDownList ID="txtAuthorEmailAddress" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="gmail.com" Value="google.com"></asp:ListItem>
                                    <asp:ListItem Text="naver.com" Value="naver.com"></asp:ListItem>
                                    <asp:ListItem Text="daum.net" Value="daum.net"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                </div>
                <asp:CheckBox ID="HasDocumentBox" runat="server" Text="협업 에디터 활성화" CssClass="custom-checkbox"/>
                
                <!-- 버튼 리스트 -->
                <div class="row-list btn-list">
                    <div>
                        <asp:Button ID="btnPost" runat="server" Text="등록" OnClick="BtnPost_Click" CssClass="sky-btn" />
                    </div>
                    <div>
                        <asp:HyperLink ID="hlList" runat="server" Text="목록" CssClass="gray-btn"/>
                    </div>
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

        document.getElementById('Content_btnPost').addEventListener('click', function () {
            var editorHtml = document.getElementById('editor').innerHTML;
            document.getElementById('<%= hiddenContent.ClientID %>').value = encodeURIComponent(editorHtml);
        });
    </script>

</asp:Content>
