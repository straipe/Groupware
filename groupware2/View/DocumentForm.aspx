<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="DocumentForm.aspx.cs" Inherits="groupware2.View.DocumentForm" %>

<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="sm" EnablePageMethods="true" runat="server"/>
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
                <img src="~/Content/Images/refresh-button.png" style="width: 20px; margin-left:10px; cursor:pointer;" runat="server" onclick="location.reload();"/>
                <img src="~/Content/Images/view-icon.png" style="width: 20px; margin-left:10px;" runat="server"/>
                <span class="text-gray">
                    <asp:Label ID="lblView" runat="server" Text="1"></asp:Label>
                </span>
            </div>
            <hr class="gray-line"/>

            <!-- 문서 제목 입력 -->
            <asp:Label ID="lblTitle" runat="server" Text="제목" CssClass="form-label" />
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
                    <asp:Button ID="btnLoad" runat="server" Text="PDF" CssClass="sky-btn" OnClientClick="saveDocumentToDB()" />
                    <button id="btnUpdate" type="button" class="sky-btn" onclick="saveDocumentToDB()">저장</button>
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
        let baseVersion = 0;

        let autoSaveInterval;

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
                const updates = JSON.parse(content);

                // 수신 Data Debug
                //console.log("<수신 내역>")
                //console.log(updates);

                editorInstance.enableReadOnlyMode("receive-lock");
                isSyncing = true;
                for (let i = 0; i < updates.length; i++) {
                    let update = updates[i];

                    if (update.__className === "InsertOperation") applyInsertOperation(editorInstance, update);
                    else if (update.__className === "MoveOperation") applyMoveOperation(editorInstance, update);
                    else if (update.__className === "AttributeOperation") applyAttributeOperation(editorInstance, update);
                    else if (update.__className === "SplitOperation") applySplitOperation(editorInstance, update);
                    else if (update.__className === "MergeOperation") applyMergeOperation(editorInstance, update);
                    else if (update.__className === "RenameOperation") applyRenameOperation(editorInstance, update);
                }
                isSyncing = false;
                editorInstance.disableReadOnlyMode("receive-lock");
            };

            docHub.client.ReceiveView = function (view) {
                $("#<%= lblView.ClientID %>").text(view);
                if (view === 1 && autoSaveInterval == undefined) startAutoSave();
            }

            // 입력 시 변경 사항 전송
            $("#<%= txtTitle.ClientID %>").on("input", function () {
                docHub.server.updateTitle(groupName, $(this).val());
            });

            editorInstance.model.document.on('change:data', function (evt, batch) {
                if (isSyncing) return;
                // 송신 Data Debug
                //console.log("<배치 내역>")
                //console.log(batch.operations.filter((op) => op.isDocumentOperation && op.baseVersion > baseVersion));
                const sendOperations = batch.operations.filter((op) => op.isDocumentOperation && op.baseVersion > baseVersion).map((op) => op.toJSON());
                docHub.server.updateContent(groupName, JSON.stringify(sendOperations));
                baseVersion = sendOperations.at(-1).baseVersion;
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
            try {
                editor.model.change(writer => {
                    // operation에 속한 노드, 필요한 정보를 담고 있다. (textData 혹은 p태그 등)
                    let node = operation.nodes[0];

                    // nodes.data가 존재하면 text를 insert한다.
                    if (node.data !== undefined) {

                        let position = editor.model.createPositionFromPath(
                            editor.model.document.getRoot(operation.position.root),
                            operation.position.path
                        );

                        // 텍스트 삽입 디버그
                        //console.log(editor.model.document.getRoot().getChild(0)); 
                        //console.log(node.attributes)
                        //console.log(operation.position.path)
                        if (node.attributes !== undefined) {
                            if (node.attributes.listIndent !== undefined) {
                                delete node.attributes.listIndent;
                                delete node.attributes.listItemId;
                                delete node.attributes.listType;
                            }
                            writer.insertText(node.data, node.attributes, position);
                        }
                        else writer.insertText(node.data, position);

                    }
                    // nodes.name이 존재하면 태그를 insert한다.
                    else if (node.name !== undefined) {

                        // 태그의 자식 태그에 text 정보가 있다.
                        if (node.children !== undefined) {
                            let start = 0;
                            if (operation.position.path.length == 1 && operation.position.path[0] === 0) {
                                start = 1;
                                const root = editor.model.document.getRoot();
                                const firstParagraph = root.getChild(0);

                                // 태그의 스타일 정보가 있다.
                                if (node.attributes !== undefined) writer.setAttributes(node.attributes, firstParagraph);

                                if (node.children[0].attributes !== undefined) writer.insertText(node.children[0].data, node.children[0].attributes, firstParagraph, 0);
                                else writer.insertText(node.children[0].data, firstParagraph, 0);
                            }
                            let path = operation.position.path;
                            for (let i = start; i < operation.nodes.length; i++) {
                                node = operation.nodes[i];
                                let tag = node.name;
                                let child = node.children[0];
                                let text = child.data;
                                let element = writer.createElement(tag);

                                if (node.attributes !== undefined) writer.setAttributes(node.attributes, element);

                                let position = editor.model.createPositionFromPath(
                                    editor.model.document.getRoot(operation.position.root), path
                                );

                                writer.insert(element, position);
                                path[0]++;

                                if (child.attributes !== undefined) writer.insertText(text, child.attributes, element);
                                else writer.insertText(text, element);
                            }
                        } else {
                            let tag = node.name;
                            // 2줄 이상 삭제 + 첫 줄 포함이면 paragraph 태그 자동 생성 현상이 발생하는 예외를 방지
                            if (tag === 'paragraph' && operation.position.path.length == 1 && operation.position.path[0] === 0) return;
                            let element = writer.createElement(tag);

                            if (node.attributes !== undefined) writer.setAttributes(node.attributes, element);

                            let position = editor.model.createPositionFromPath(
                                editor.model.document.getRoot(operation.position.root), operation.position.path
                            );
                            writer.insert(element, position);
                        }
                    }
                });
            } catch (error) {
                console.log("[수신] 삽입 에러 발생")
                console.log(error.message)
            }
            
        }

        function applyMoveOperation(editor, operation) {
            try {
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
            } catch (error) {
                console.log("[수신] 제거 에러 발생")
                console.log(error.message);
            }
            
        }

        function applyAttributeOperation(editor, operation) {
            try {
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
            } catch (error) {
                console.log("[수신] 속성 에러 발생")
                console.log(error.message);
            }
            
        }

        function applySplitOperation(editor, operation) {
            try {
                editor.model.change(writer => {
                    const splitPosition = editor.model.createPositionFromPath(
                        editor.model.document.getRoot(operation.splitPosition.root),
                        operation.splitPosition.path
                    );
                    writer.split(splitPosition);
                });
            } catch (error) {
                console.log("[수신] 분할 에러 발생")
                console.log(error.message)
            }
            
        }

        function applyMergeOperation(editor, operation) {
            try {
                editor.model.change(writer => {
                    operation.sourcePosition.path.pop()

                    const sourcePosition = editor.model.createPositionFromPath(
                        editor.model.document.getRoot(operation.sourcePosition.root),
                        operation.sourcePosition.path
                    );

                    writer.merge(sourcePosition)
                });
            } catch (error) {
                console.log("[수신] 병합 에러 발생")
                console.log(error.message)
            }
            
        }

        function applyRenameOperation(editor, operation) {
            try {
                editor.model.change(writer => {
                    operation.position.path.push(0)

                    const sourcePosition = editor.model.createPositionFromPath(
                        editor.model.document.getRoot("main"),
                        operation.position.path
                    );

                    const sourceParent = sourcePosition.parent;
                    writer.rename(sourceParent, operation.newName);
                })
            } catch (error) {
                console.log("[수신] 태그 에러 발생")
                console.log(error.message)
            }
            
        }

        function startAutoSave() {
            console.log("자동 임시저장 시작!")
            autoSaveInterval = setInterval(() => saveDocumentToRedis(), 5000);
        }

        function saveDocumentToRedis() {
            let title = $("#<%= txtTitle.ClientID %>").val();
            let content = editorInstance.getData();
            PageMethods.SaveDocumentToRedis(groupName, title, content, function (result) {
                console.log("임시저장 완료!");
                console.log(`제목:${title}`);
                console.log(`내용:${content}`);
            });
        }

        function saveDocumentToDB() {
            let title = $("#<%= txtTitle.ClientID %>").val();
            let content = document.querySelector("#editor").innerHTML;
            PageMethods.SaveDocumentToDB(groupName, title, content, function (result) {
                showAlert(result);
            });
        }

        // 처리 결과에 따른 Alert
        function showAlert(message) {
            let title = "경고";
            let icon = "error";
            if (message.includes("정상")) {
                title = "성공";
                icon = "success";
            }
            Swal.fire({
                title: title,
                text: message,
                icon: icon,
                confirmButtonText: "확인",
                customClass: {
                    confirmButton: "blue-btn"
                }
            });
        }
    </script>
</asp:Content>