using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Runtime.Remoting.Contexts;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using groupware2.Models;
using groupware2.Utils;

namespace groupware2
{
    public partial class Detail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsAjaxRequest()) return;
            if (!IsPostBack)
            {
                int Id = int.Parse(Request.QueryString["Id"]);

                using (var context = new AppDBContext())
                {
                    LoadPost(Id);
                    Session["CommentPageIndex"] = 0;
                    Session["CommentsPerPage"] = App_GlobalResources.Constants.CommentsPerPage;

                    // 총 댓글 수와 페이지 크기(PageSize)로 총 페이지 수 계산
                    int totalComments = context.Comments.Count(c => c.PostId == Id && c.IsRemove == false);
                    int pageSize = Convert.ToInt32(Session["CommentsPerPage"]); // 페이지당 표시할 댓글 수
                    int totalCommentPages = (int)Math.Ceiling((double)totalComments / pageSize); // 총 페이지 수 계산
                    Session["TotalCommentPages"] = totalCommentPages;
                }

                bool isAdmin = Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
                hlList.NavigateUrl = isAdmin ? "AdminList.aspx" : "List.aspx";

            }
            LoadComments();
        }

        private void LoadPost(int Id)
        {
            using (var context = new AppDBContext())
            {
                var post = context.Posts.FirstOrDefault(p => p.Id == Id);
                if (post != null)
                {
                    lblTitle.Text = HttpUtility.HtmlDecode(post.Title);
                    lblContent.Text = HttpUtility.HtmlDecode(post.Content);
                    lblAuthorName.Text = HttpUtility.HtmlDecode(post.AuthorName);
                    lblCreatedAt.Text = post.CreatedAt.ToString("yyyy-MM-dd");
                    lblView.Text = post.Views.ToString();
                    if (!post.HasDocument) lbDocument.Visible = false;

                    // IP를 활용한 조회수 저장
                    var db = RedisManager.Connection.GetDatabase();
                    string key = $"Post:{Id}";
                    string userIP = Request.UserHostAddress;
                    if (!db.SetContains(key, userIP))
                    {
                        db.SetAdd(key, userIP);
                        post.Views += 1;
                        context.SaveChanges();
                    }
                }
                else
                {
                    Response.Redirect(hlList.NavigateUrl, false);  // 게시글을 찾지 못하면 목록 페이지로 리다이렉트
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
        }

        private void LoadComments()
        {
            using (var context = new AppDBContext())
            {
                int Id = int.Parse(Request.QueryString["Id"]);

                int pageIndex = Convert.ToInt32(Session["CommentPageIndex"]);
                int pageSize = Convert.ToInt32(Session["CommentsPerPage"]);
                var comments = context.Comments
                    .Where(c => !c.IsRemove && c.PostId == Id)
                    .OrderByDescending(c => c.CreatedAt)
                    .Skip(pageIndex * pageSize)
                    .Take(pageSize)
                    .ToList();

                rptComments.DataSource = comments;
                rptComments.DataBind();
                paginationControls.Visible = comments.Any();
                lblNoComments.Visible = !comments.Any();
                commentsHr.Visible = !comments.Any();

                int PageNavSize = Convert.ToInt32(App_GlobalResources.Constants.PageSize);
                BtnPrevious.Enabled = pageIndex != 0;
                BtnPrevious.Visible = BtnPrevious.Enabled;
                BtnNext.Enabled = pageIndex != (int)Session["TotalCommentPages"]-1;
                BtnNext.Visible = BtnNext.Enabled;
                GeneratePageNumbers();
            }
        }

        private void GeneratePageNumbers()
        {
            int totalPages = Session["TotalCommentPages"] != null ? (int)Session["TotalCommentPages"] : 0;
            int pageIndex = Session["CommentPageIndex"] != null ? (int)Session["CommentPageIndex"] : 0;
            int PageNavSize = Convert.ToInt32(App_GlobalResources.Constants.PageSize);
            int StartPageNum = pageIndex / PageNavSize;
            for (int i = StartPageNum * PageNavSize; i < (StartPageNum + 1) * PageNavSize && i < totalPages; i++)
            {
                string pageNumber = (i + 1).ToString();  // 페이지 번호 계산
                string commandArgument = (i).ToString();  // 페이지 인덱스

                LinkButton pageLink = new LinkButton
                {
                    ID = "LinkButton_" + i,
                    Text = pageNumber,
                    CommandArgument = commandArgument,
                    CssClass = "page-number"
                };
                pageLink.Click += PageButton_Click;  // 클릭 이벤트 핸들러
                
                if (pageNumbers != null)
                {
                    if (i == pageIndex) pageLink.CssClass += " active";

                    // 페이지 번호를 표시할 div에 동적으로 추가
                    pageNumbers.Controls.Add(pageLink);
                }
                else
                {
                    string script = "alert('Error: pageNumbers is null.');";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "getCommentPageError", script, true);
                }
            }
        }

        protected void BtnPrevious_Click(object sender, EventArgs e)
        {
            int PageNavSize = Convert.ToInt32(App_GlobalResources.Constants.PageSize);
            int pageIndex = (int)Session["CommentPageIndex"];
            Session["CommentPageIndex"] = Math.Max(pageIndex - PageNavSize, 0);
            Reload();
        }

        protected void BtnNext_Click(object sender, EventArgs e)
        {
            int PageNavSize = Convert.ToInt32(App_GlobalResources.Constants.PageSize);
            int pageIndex = (int)Session["CommentPageIndex"];
            Session["CommentPageIndex"] = Math.Min(pageIndex + PageNavSize, (int)Session["TotalCommentPages"]-1);
            Reload();
        }

        protected void PageButton_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int pageIndex = Convert.ToInt32(btn.CommandArgument);
            Session["CommentPageIndex"] = pageIndex;
            Reload();
        }

        protected void BtnWriteComment_Click(object sender, EventArgs e)
        {
            string CommentAuthorName = HttpUtility.HtmlEncode(txtCommentAuthorName.Text);
            string CommentAuthorPassword = Utils.SecurityHelper.HashPassword(txtCommentAuthorPassword.Text);
            string CommentAuthorEmail = txtCommentAuthorEmailID.Text+"@"+txtCommentAuthorEmailAddress.Text;
            string CommentContent = HttpUtility.HtmlEncode(txtCommentContent.Text);
            var NowPostId = int.Parse(Request.QueryString["Id"]);

            if (string.IsNullOrWhiteSpace(CommentAuthorName) || string.IsNullOrWhiteSpace(CommentAuthorPassword) || string.IsNullOrWhiteSpace(CommentAuthorEmail)
                || string.IsNullOrWhiteSpace(CommentContent))
            {
                ScriptHelper.ShowAlert(this, "경고", "공백을 제외하고 댓글 내용을 입력해 주세요.", "warning", "failPostComment");
            }
            else if (!MailHelper.IsValidEmail(CommentAuthorEmail))
            {
                ScriptHelper.ShowAlert(this, "경고", "유효하지 않은 이메일 주소입니다.", "error", "failPostCommentForEmail");
            }
            else
            {
                using (var context = new AppDBContext())
                {
                    var newComment = new Comment
                    {
                        PostId = NowPostId,
                        AuthorName = CommentAuthorName,
                        AuthorPassword = CommentAuthorPassword,
                        AuthorEmail = HttpUtility.HtmlEncode(txtCommentAuthorEmailID.Text) + "@" + HttpUtility.HtmlEncode(txtCommentAuthorEmailAddress.Text),
                        Content = CommentContent,
                        CreatedAt = DateTime.Now
                    };
                    context.Comments.Add(newComment);
                    context.SaveChanges();

                    txtCommentAuthorName.Text = "";
                    txtCommentAuthorPassword.Text = "";
                    txtCommentAuthorEmailID.Text = "";
                    txtCommentAuthorEmailAddress.SelectedIndex = 0;
                    txtCommentContent.Text = "";

                    // 이메일 전송 로직 추가
                    try
                    {
                        MailMessage mailMessage = MailHelper.CreateCommentMailMessageByUser("등록", CommentContent);
                        MailHelper.SendEmail(mailMessage, CommentAuthorEmail);
                    }
                    catch (Exception ex)
                    {
                        // 이메일 전송 실패 시 로그 처리 및 사용자 알림
                        ScriptHelper.ShowAlert(this, "경고", "댓글이 등록되었지만, 이메일 전송에 실패했습니다. 관리자에게 문의하세요.", "error", "sendEmailFromManagerError");
                        Debug.WriteLine(ex);
                        return;
                    }
                    ScriptHelper.ShowAlert(this, "성공", "댓글이 정상적으로 등록되었습니다.", "success", "successPostComment", $"Detail.aspx?Id={NowPostId}");
                }
            }
        }

        protected void BtnDocument_Click(object sender, EventArgs e)
        {
            int Id = int.Parse(Request.QueryString["Id"]); ;
            using (var context = new AppDBContext())
            {
                var document = context.Documents.FirstOrDefault(d => d.PostId == Id);
                if (document != null)
                {
                    string script = $"window.location.href='DocumentForm.aspx?PostId={Id}&Id={document.Id}';";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "moveDocument", script, true);
                } else
                {
                    ScriptHelper.ShowAlert(this, "경고", "잘못된 경로입니다.", "error", "failMoveDocument");
                }
            }
        }

        [WebMethod]
        public static string SaveEditComment(int CommentId, string Content, string Password)
        {
            using (var context = new AppDBContext())
            {
                var comment = context.Comments.FirstOrDefault(c => c.Id == CommentId);
                if (comment != null)
                {
                    if (comment.IsRemove)
                    {
                        return "이미 삭제된 댓글입니다.";
                    }
                    else if (Utils.SecurityHelper.VerifyPassword(Password, comment.AuthorPassword))
                    {
                        comment.Content = HttpUtility.HtmlEncode(Content);
                        context.SaveChanges();

                        // 이메일 전송 로직 추가
                        try
                        {
                            MailMessage mailMessage = Utils.MailHelper.CreateCommentMailMessageByUser("수정", Content);
                            Utils.MailHelper.SendEmail(mailMessage, comment.AuthorEmail);
                        }
                        catch (Exception ex)
                        {
                            // 이메일 전송 실패 시 로그 처리 및 사용자 알림
                            return $"댓글이 수정되었지만, 이메일 전송에 실패했습니다. 오류: {ex.Message}";
                        }

                        return "댓글이 정상적으로 수정되었습니다.";
                    }
                    else
                    {
                        return "잘못된 비밀번호입니다.";
                    }
                }

                return "존재하지 않는 댓글입니다.";
            }
        }

        [WebMethod]
        public static string DeleteComment(int CommentId, string Password)
        {
            using (var context = new AppDBContext())
            {
                var comment = context.Comments.FirstOrDefault(c => c.Id == CommentId);
                if (comment != null)
                {
                    if (comment.IsRemove)
                    {
                        return "이미 삭제된 댓글입니다.";
                    }
                    else if (Utils.SecurityHelper.VerifyPassword(Password, comment.AuthorPassword))
                    {
                        comment.IsRemove = true;
                        context.SaveChanges();

                        // 이메일 전송 로직 추가
                        try
                        {
                            MailMessage mailMessage = Utils.MailHelper.CreateCommentMailMessageByUser("삭제", comment.Content);
                            Utils.MailHelper.SendEmail(mailMessage, comment.AuthorEmail);
                        }
                        catch (Exception ex)
                        {
                            // 이메일 전송 실패 시 로그 처리 및 사용자 알림
                            return $"댓글이 삭제되었지만, 이메일 전송에 실패했습니다. 오류: {ex.Message}";
                        }

                        return "댓글이 정상적으로 삭제되었습니다.";
                    }
                    else
                    {
                        return "잘못된 비밀번호입니다.";
                    }
                }

                return "존재하지 않는 댓글입니다.";
            }
        }

        private bool IsAjaxRequest()
        {
            return Request.Headers["X-Requested-With"] == "XMLHttpRequest";
        }

        private void Reload()
        {
            // JavaScript로 새로고침 실행
            ScriptManager.RegisterStartupScript(this, GetType(), "reload",
                "if (!sessionStorage.getItem('reloaded')) { " +
                "   sessionStorage.setItem('reloaded', 'true'); " +
                "   window.location.reload(); " +
                "} else { sessionStorage.removeItem('reloaded'); }", true);
        }
    }
}