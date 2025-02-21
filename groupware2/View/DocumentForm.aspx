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
        let startOperIdx = 1;

        // CKEditor 설정
        DecoupledEditor.create(document.querySelector('#editor'), editorConfig).then(editor => {
            editorInstance = editor;
            document.querySelector('#editor-toolbar').appendChild(editor.ui.view.toolbar.element);
            document.querySelector('#editor-menu-bar').appendChild(editor.ui.view.menuBarView.element);
            const operations = editorInstance.model.document.history.getOperations();
            startOperIdx = operations.length;
        });


        // SignalR를 위한 송신, 수신 함수
        $(function () {
            var docHub = $.connection.documentHub;

            // 서버에서 데이터 수신
            docHub.client.ReceiveTitle = function (title) {
                $("#<%= txtTitle.ClientID %>").val(title);
            };

            docHub.client.ReceiveContent = function (content) {
                const updates = JSON.parse(content);
                for (let i = 0; i < updates.length; i++) {
                    let update = updates[i];
                    isSyncing = true;
                    //editorInstance.model.applyOperation(update);
                    if (update.__className === "InsertOperation") applyInsertOperation(editorInstance, update);
                    else if (update.__className === "MoveOperation") applyMoveOperation(editorInstance, update);
                    else if (update.__className === "AttributeOperation") applyAttributeOperation(editorInstance, update);
                    else if (update.__className === "SplitOperation") applySplitOperation(editorInstance, update);
                    else if (update.__className === "MergeOperation") applyMergeOperation(editorInstance, update);
                    else if (update.__className === "RenameOperation") applyRenameOperation(editorInstance, update);
                }

                console.log("<수신 내역>")
                console.log(updates);

                //isSyncing = true;
                //editorInstance.setData(content);
                //isSyncing = false;
            };

            docHub.client.ReceiveView = function (view) {
                $("#<%= lblView.ClientID %>").text(view);
            }

            // 입력 시 변경 사항 전송
            $("#<%= txtTitle.ClientID %>").on("input", function () {
                docHub.server.updateTitle(groupName, $(this).val());
            });

            editorInstance.model.document.on('change:data', function (evt, batch) {
                if (isSyncing) {
                    isSyncing = false;
                    return;
                }
                console.log("<배치 내역>")
                console.log(batch.operations.filter((op) => op.isDocumentOperation));
                const sendOperations = batch.operations.filter((op) => op.isDocumentOperation).map((op) => op.toJSON());
                docHub.server.updateContent(groupName, JSON.stringify(sendOperations));
                //startOperIdx = operations.length;

                //if (isSyncing) return;
                //setTimeout(() => docHub.server.updateContent(groupName, editorInstance.getData()), 10);
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

        function applyInsertOperation(editor, operation) {
            editor.model.change(writer => {
                const position = editor.model.createPositionFromPath(
                    editor.model.document.getRoot(operation.position.root),
                    operation.position.path
                );

                if (operation.nodes[0].data !== undefined) {
                    if (operation.nodes[0].attributes !== undefined) writer.insertText(operation.nodes[0].data, operation.nodes[0].attributes, position);
                    else writer.insertText(operation.nodes[0].data, position);
                } else if (operation.nodes[0].name !== undefined) {
                    const element = writer.createElement(operation.nodes[0].name);
                    writer.insert(element, position);
                    
                }
            });
        }

        function applyMoveOperation(editor, operation) {
            editor.model.change(writer => {
                const sourceRange = editor.model.createRange(
                    editor.model.createPositionFromPath(
                        editor.model.document.getRoot(operation.sourcePosition.root),
                        operation.sourcePosition.path
                    ),
                    editor.model.createPositionFromPath(
                        editor.model.document.getRoot(operation.sourcePosition.root),
                        operation.sourcePosition.path.map((v, i) => (i === operation.sourcePosition.path.length - 1 ? v + operation.howMany : v))
                    )
                );

                const targetPosition = editor.model.createPositionFromPath(
                    editor.model.document.getRoot(operation.targetPosition.root),
                    operation.targetPosition.path
                );

                writer.move(sourceRange, targetPosition);
            });
        }

        function applyAttributeOperation(editor, operation) {
            editor.model.change(writer => {
                if (operation.key.startsWith("selection:")) {
                    const selectionKey = operation.key.substring("selection:".length);
                    writer.setSelectionAttribute(selectionKey, operation.newValue);
                }
                else {
                    const startPosition = editor.model.createPositionFromPath(
                        editor.model.document.getRoot(operation.range.start.root),
                        operation.range.start.path
                    );

                    const endPosition = editor.model.createPositionFromPath(
                        editor.model.document.getRoot(operation.range.end.root),
                        operation.range.end.path
                    );

                    const range = editor.model.createRange(startPosition, endPosition);

                    writer.setAttribute(operation.key, operation.newValue, range);
                }
            });
        }

        function applySplitOperation(editor, operation) {
            editor.model.change(writer => {
                const splitPosition = editor.model.createPositionFromPath(
                    editor.model.document.getRoot(operation.splitPosition.root),
                    operation.splitPosition.path
                );
                writer.split(splitPosition);
            });
        }

        function applyMergeOperation(editor, operation) {
            editor.model.change(writer => {
                operation.sourcePosition.path.pop()

                const sourcePosition = editor.model.createPositionFromPath(
                    editor.model.document.getRoot(operation.sourcePosition.root),
                    operation.sourcePosition.path
                );

                writer.merge(sourcePosition)
            });
        }

        function applyRenameOperation(editor, operation) {
            editor.model.change(writer => {
                operation.position.path.push(0)

                const sourcePosition = editor.model.createPositionFromPath(
                    editor.model.document.getRoot("main"),
                    operation.position.path
                );
                
                const sourceParent = sourcePosition.parent;
                writer.rename(sourceParent, operation.newName);
            })
        }
    </script>
</asp:Content>