<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="DocumentForm.aspx.cs" Inherits="groupware2.View.DocumentForm" %>

<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <form id="form1" runat="server">
    <div class="container">
        <div class="post-form">
            <h3 class="text-bold">공동 문서 편집</h3>

            <!-- 작성자 이름, 작성날짜 -->
            <div style="display: flex; gap: 5px; padding-left: 8px;">
                <span class="text-gray">
                    <asp:Label ID="lblAuthorName" runat="server" Text=""></asp:Label>
                </span>
                <span class="text-gray">
                    <asp:Label ID="lblCreatedAt" runat="server" Text=""></asp:Label>
                </span>
                <img src="~/Content/Images/view-icon.png" style="width: 20px; margin-left:10px;" runat="server"/>
                <span class="text-gray">
                    <asp:Label ID="lblView" runat="server" Text="1"></asp:Label>
                </span>
            </div>
            <hr class="gray-line"/>

            <!-- 문서 이름 입력 -->
            <asp:Label ID="lblTitle" runat="server" Text="문서 이름" CssClass="form-label" />
            <asp:TextBox ID="txtTitle" runat="server" Width="100%" CssClass="form-control" />
            
            <!-- 문서 내용 입력 -->
            <asp:Label ID="lblContent" runat="server" Text="내용" CssClass="form-label" />
            <div class="editor-container editor-container_document-editor editor-container_include-style" id="editor-container">
                <div class="editor-container__menu-bar" id="editor-menu-bar"></div>
                <div class="editor-container__toolbar" id="editor-toolbar"></div>
                <div class="editor-container__editor-wrapper">
                    <div class="editor-container__editor"><div id="editor"></div></div>
                </div>
             </div>
            
            <!-- 버튼 -->
            <div class="row-list">
                <div class="row-list">
                    <asp:Button ID="btnLoad" runat="server" Text="PDF" CssClass="sky-btn" OnClick="BtnUpdate_Click" />
                    <asp:Button ID="btnUpdate" runat="server" Text="저장" CssClass="sky-btn" OnClick="BtnUpdate_Click" />
                </div>
                <div class="row-list">
                    <button type="button" class="gray-btn" onclick="location.href='Detail.aspx?Id=<%= HttpUtility.HtmlEncode(Request.QueryString["PostId"]) %>';">뒤로가기</button>
                    <asp:HyperLink ID="hlList" runat="server" Text="목록" CssClass="gray-btn"/>
                </div>
            </div>
        </div>
    </div>
    </form>
    <!-- SignalR -->
    <script src="/Scripts/jquery-3.7.1.min.js"></script>
    <script src="/Scripts/jquery.signalR-2.4.3.min.js"></script>
    <script src="/signalr/hubs"></script>

    <!-- CKEditor -->
    <script src="https://cdn.ckeditor.com/ckeditor5/44.1.0/ckeditor5.umd.js" crossorigin="anonymous"></script>
    <script src="https://cdn.ckeditor.com/ckeditor5/44.1.0/translations/ko.umd.js" crossorigin="anonymous"></script>
    <script src="<%= ResolveUrl("~/Scripts/editor.js") %>"></script>
    <script>
        let editorInstance;
        let isSyncing = false;
        var groupName = '<%= HttpUtility.HtmlEncode(Request.QueryString["Id"]) %>';

        // CKEditor 설정
        DecoupledEditor.create(document.querySelector('#editor'), editorConfig).then(editor => {
            editorInstance = editor;
            document.querySelector('#editor-toolbar').appendChild(editor.ui.view.toolbar.element);
            document.querySelector('#editor-menu-bar').appendChild(editor.ui.view.menuBarView.element);
        });

        // SignalR를 위한 송신, 수신 함수
        $(function () {
            var docHub = $.connection.documentHub;

            // 서버에서 데이터 수신
            docHub.client.ReceiveTitle = function (title) {
                $("#<%= txtTitle.ClientID %>").val(title);
            };

            docHub.client.ReceiveContent = function (content) {
                isSyncing = true;
                editorInstance.setData(content);
                isSyncing = false;
            };

            docHub.client.ReceiveView = function (view) {
                $("#<%= lblView.ClientID %>").text(view);
            }

            // 입력 시 변경 사항 전송
            $("#<%= txtTitle.ClientID %>").on("input", function () {
                docHub.server.updateTitle(groupName, $(this).val());
            });

            editorInstance.model.document.on('change:data', function () {
                if (isSyncing) return;
                setTimeout(() => docHub.server.updateContent(groupName, editorInstance.getData()), 10);
            });

            $.connection.hub.start().done(function () {
                console.log("SignalR 연결 완료!");
                docHub.server.joinGroup(groupName);
                console.log(groupName+"번 그룹에 참여하셨습니다.");
            });

            window.addEventListener("beforeunload", function () {
                docHub.server.leaveGroup(groupName);
                $.connection.hub.stop()
            });
        });
    </script>
</asp:Content>