<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="groupware2.Detail" %>

<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    
    <form id="form1" runat="server">
        <asp:ScriptManager ID="sm" EnablePageMethods="true" runat="server"/>
        <div class="container">
            <!-- 문서 제목 -->
            <h3 class="text-bold">
                <asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>
            </h3>

            <!-- 작성자, 작성 날짜 -->
            <div style="display: flex; gap: 5px; padding-left:8px;">
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

            <!-- 문서 내용 -->
            <div style="min-height:200px; padding: 8px;">
                <asp:Label ID="lblContent" runat="server" Text="" CssClass="ck-content content-pre"></asp:Label>
            </div>
            <hr class="gray-line"/>

            <!-- 댓글 리스트 -->
            <div id="commentsSection" class="mb-3">
                <asp:Repeater ID="rptComments" runat="server">
                    <ItemTemplate>
                        <div class="comment" id="comment_<%# Eval("Id") %>">
                            <div id="comment-content-<%# Eval("Id") %>" style="display: block;">
                                <p style="margin-bottom: 20px;">
                                    <strong><%# Eval("AuthorName") %></strong> - 
                                    <em><%# Eval("CreatedAt", "{0:yyyy-MM-dd}") %></em>
                                    <asp:LinkButton ID="BtnUpdateComment" runat="server" Text="수정"
                                        OnClientClick=<%# "showEditForm("+Eval("Id")+"); return false;" %>
                                        CssClass="btn-comment-update" />
                                    <asp:LinkButton ID="BtnDeleteComment" runat="server" Text="삭제" 
                                        OnClientClick=<%# "showDeleteForm("+Eval("Id")+"); return false;" %>
                                        CssClass="btn-comment-delete" />
                                    
                                </p>
                                <p class="content-pre"><%# Eval("Content") %></p>
                            </div>
                                
                            <!-- 댓글 수정 폼 -->
                            <div id="editForm_<%# Eval("Id") %>" style="display: none;" class="edit-comment-form">
                                <div class="row-list">
                                    <div class="col-half">
                                        <label for="txtUpdateCommentAuthorName_<%# Eval("Id") %>" class="text-gray" >작성자 이름</label>
                                        <input type="text" id="txtUpdateCommentAuthorName_<%# Eval("Id") %>" class="form-control" value='<%# Eval("AuthorName") %>' disabled />
                                    </div>
                                    <div class="col-half">
                                        <label for="txtUpdateCommentAuthorPassword_<%# Eval("Id") %>" class="text-gray" >비밀번호</label>
                                        <input type="password" id="txtUpdateCommentAuthorPassword_<%# Eval("Id") %>" class="form-control"/>
                                    </div>
                                </div>
                                <label for="txtUpdateCommentContent_<%# Eval("Id") %>" class="text-gray">내용</label>
                                <textarea id="txtUpdateCommentContent_<%# Eval("Id") %>" rows="4"><%# Eval("Content") %></textarea>
                                <div style="display: flex; gap: 10px">
                                    <button type="button" id="BtnSaveUpdateComment_<%# Eval("Id") %>" class="sky-btn" onclick="saveEditComment(<%# Eval("Id") %>); return false;">
                                        저장
                                    </button>
                                    <button type="button" id="BtnCancelUpdateComment_<%# Eval("Id") %>" class="gray-btn" onclick="hideEditForm(<%# Eval("Id") %>); return false;">
                                        취소
                                    </button>
                                </div>
                            </div>

                            <!-- 댓글 삭제 폼 -->
                            <div id="deleteForm_<%# Eval("Id") %>" style="display: none;" class="delete-comment-form">
                                <div class="row-list">
                                    <div class="col-half">
                                        <label for="txtDeleteCommentAuthorName_<%# Eval("Id") %>" class="text-gray" >작성자 이름</label>
                                        <input type="text" id="txtDeleteCommentAuthorName_<%# Eval("Id") %>"" class="form-control" value='<%# Eval("AuthorName") %>' disabled />
                                    </div>
                                    <div class="col-half">
                                        <label for="txtDeleteCommentAuthorPassword_<%# Eval("Id") %>" class="text-gray" >비밀번호</label>
                                        <input type="password" id="txtDeleteCommentAuthorPassword_<%# Eval("Id") %>"" class="form-control"/>
                                    </div>
                                </div>
                                <div style="display: flex; gap: 10px">
                                    <button type="button" id="BtnSaveDeleteComment_<%# Eval("Id") %>" class="red-btn" onclick="sendDeleteComment(<%# Eval("Id") %>); return false;">
                                        삭제
                                    </button>
                                    <button type="button" id="BtnCancelDeleteComment_<%# Eval("Id") %>" class="gray-btn" onclick="hideDeleteForm(<%# Eval("Id") %>); return false;">
                                        취소
                                    </button>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoComments" runat="server" CssClass="text-no-comments" Text="등록된 댓글이 없습니다." Visible="false"></asp:Label>
                <hr id="commentsHr" class="gray-line" runat="server" />
            </div>

            <!-- 페이징 -->
            <div class="pagination" id="paginationControls" runat="Server">
                <asp:Button ID="BtnPrevious" runat="server" Text="이전" OnClick="BtnPrevious_Click"  />

                <div class="page-numbers" id ="pageNumbers" runat="server">
       
                </div>

                <asp:Button ID="BtnNext" runat="server" Text="다음" OnClick="BtnNext_Click" />
            </div>

            <!-- 댓글 입력 폼 -->
            <div class="row-list">
                <span class="form-label" style="font-weight: bold">댓글</span>
                <div>
                    <asp:Button ID="btnPostComment" runat="server" Text="등록" OnClick="BtnWriteComment_Click" CssClass="sky-btn"/>
                </div>
            </div>
            <div class="row-list">
                <div class="col-half row-list" style="gap:5px;">
                    <div style="width:calc(50% - 2.5px);">
                        <asp:Label ID="lblCommentAuthorName" runat="server" Text="작성자 이름" CssClass="text-gray" />
                        <asp:TextBox ID="txtCommentAuthorName" runat="server" CssClass="form-control" />
                    </div>
                    <div style="width:calc(50% - 2.5px);">
                        <asp:Label ID="lblCommentAuthorPassword" runat="server" Text="비밀번호" CssClass="text-gray" />
                        <asp:TextBox ID="txtCommentAuthorPassword" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                </div>
                <div class="col-half"">
                    <asp:Label ID="lblAuthorEmail" runat="server" Text="이메일" CssClass="text-gray" />
                    <div class="row-list" style="gap:3px;">
                        <div style="width:52%;">
                            <asp:TextBox ID="txtCommentAuthorEmailID" runat="server" CssClass="form-control" />
                        </div>
                        <div class="text-center form-label" style=" font-size:20px; line-height:35px;">
                            @
                        </div>
                        <div style="width:40%;">
                            <asp:DropDownList ID="txtCommentAuthorEmailAddress" runat="server" CssClass="form-control">
                                <asp:ListItem Text="gmail.com" Value="google.com"></asp:ListItem>
                                <asp:ListItem Text="naver.com" Value="naver.com"></asp:ListItem>
                                <asp:ListItem Text="daum.net" Value="daum.net"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
            <asp:Label ID="lblCommentContent" runat="server" Text="내용" CssClass="text-gray"/>
            <asp:TextBox ID="txtCommentContent" runat="server" TextMode="MultiLine" CssClass="styled-textarea"/>
            
            <!-- 버튼 -->
            <div class="row-list">
                <div class="row-list">
                    <button type="button" class="gray-btn" onclick="location.href='UpdateForm.aspx?Id=<%= HttpUtility.HtmlEncode(Request.QueryString["Id"]) %>';">수정</button>
                    <button type="button" class="gray-btn" onclick="location.href='PasswordForm.aspx?mode=delete&Id=<%= HttpUtility.HtmlEncode(Request.QueryString["Id"]) %>';">삭제</button>
                    <asp:LinkButton ID="lbDocument" runat="server" Text="공동 문서로 이동" CssClass="sky-btn" OnClick="BtnDocument_Click"></asp:LinkButton>
                </div>
                <div>
                    <asp:HyperLink ID="hlList" runat="server" Text="목록" CssClass="gray-btn"></asp:HyperLink>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        // 댓글 수정 폼 나타내기
        function showEditForm(commentId) {
            const commentContent = document.getElementById("comment-content-" + commentId);
            const editForm = document.getElementById("editForm_" + commentId);
            if (editForm) {
                editForm.style.display = "block";
                commentContent.style.display = "none";
            } else {
                console.error("editForm_" + commentId + " not found in DOM.");
            }
        }

        // 댓글 수정 폼 숨기기
        function hideEditForm(commentId) {
            const commentContent = document.getElementById("comment-content-" + commentId);
            const editForm = document.getElementById("editForm_" + commentId);
            if (editForm) {
                editForm.style.display = "none";
                commentContent.style.display = "block";
            } else {
                console.error("editForm_" + commentId + " not found in DOM.");
            }
        }

        // 댓글 수정 요청
        function saveEditComment(commentId) {
            var password = document.getElementById('txtUpdateCommentAuthorPassword_'+commentId).value;
            var content = document.getElementById('txtUpdateCommentContent_' + commentId).value;
            PageMethods.SaveEditComment(commentId, content, password, function (result) {
                showAlert(result);
            });
        }

        // 댓글 삭제 폼 나타내기
        function showDeleteForm(commentId) {
            const commentContent = document.getElementById("comment-content-" + commentId);
            const deleteForm = document.getElementById("deleteForm_" + commentId);
            if (deleteForm) {
                deleteForm.style.display = "block";
                commentContent.style.display = "none";
            } else {
                console.error("deleteForm_" + commentId + " not found in DOM.");
            }
        }

        // 댓글 삭제 폼 숨기기
        function hideDeleteForm(commentId) {
            const commentContent = document.getElementById("comment-content-" + commentId);
            const deleteForm = document.getElementById("deleteForm_" + commentId);
            if (deleteForm) {
                deleteForm.style.display = "none";
                commentContent.style.display = "block";
            } else {
                console.error("deleteForm_" + commentId + " not found in DOM.");
            }
        }

        // 댓글 삭제 요청
        function sendDeleteComment(commentId) {
            var password = document.getElementById('txtDeleteCommentAuthorPassword_' + commentId).value;
            PageMethods.DeleteComment(commentId, password, function (result) {
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
            }).then((result) => {
                if (result.isConfirmed && message.includes('정상')) window.location.reload();
            });
        }
    </script>
</asp:Content>
