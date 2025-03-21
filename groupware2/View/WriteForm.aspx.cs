using System;
using System.Web.UI;
using System.Text.RegularExpressions;
using groupware2.Utils;
using groupware2.Models;
using System.Net.Mail;
using System.Web;
using System.Diagnostics;
using System.Web.Services;

namespace groupware2
{
    public partial class WriteForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsAjaxRequest()) return;
            hlList.NavigateUrl = SecurityHelper.VerifyAdmin(Page) ? "AdminList.aspx" : "List.aspx";
        }
        protected void BtnPost_Click(object sender, EventArgs e)
        {
            string title = HttpUtility.HtmlEncode(txtTitle.Text);
            string content = HttpUtility.HtmlEncode(HttpUtility.UrlDecode(hiddenContent.Value));
            string authorName = HttpUtility.HtmlEncode(txtAuthorName.Text);
            string authorPassword = SecurityHelper.HashPassword(txtAuthorPassword.Text);
            string authorEmail = txtAuthorEmailID.Text + "@" + txtAuthorEmailAddress.Text;
            bool hasDocument = HasDocumentBox.Checked;

            if (string.IsNullOrWhiteSpace(title) || string.IsNullOrWhiteSpace(content) || string.IsNullOrWhiteSpace(authorName)
                || string.IsNullOrWhiteSpace(authorEmail))
            {
                ScriptHelper.ShowAlert(this, "경고", "공백을 제외하고 모든 칸에 내용을 정확히 입력해 주세요.", "warning", "failPostForNotFill");
            }
            else if (!MailHelper.IsValidEmail(authorEmail))
            {
                ScriptHelper.ShowAlert(this, "경고", "유효하지 않은 이메일 주소입니다.", "error", "failPostForEmail");

            }
            else
            {
                using (var context = new AppDBContext())
                {
                    var post = new Post
                    {
                        Title = title,
                        Content = content,
                        AuthorName = authorName,
                        AuthorPassword = authorPassword,
                        AuthorEmail = authorEmail,
                        HasDocument = hasDocument,
                        CreatedAt = DateTime.Now
                    };
                    context.Posts.Add(post);
                    context.SaveChanges();

                    if (hasDocument)
                    {
                        var document = new Document
                        {
                            AuthorName = authorName,
                            PostId = post.Id,
                            CreatedAt = DateTime.Now
                        };
                        context.Documents.Add(document);
                    }
                    context.SaveChanges();
                }

                // 이메일 전송 로직 추가
                try
                {
                    MailMessage mailMessage = MailHelper.CreatePostMailMessageByUser("등록", title, content);
                    MailHelper.SendEmail(mailMessage, authorEmail);
                }
                catch (Exception ex)
                {
                    // 이메일 전송 실패 시 로그 처리 및 사용자 알림
                    ScriptHelper.ShowAlert(this, "경고", "이메일 전송에 실패했습니다. ", "error", "emailError");
                    Debug.WriteLine(ex);
                    return;
                }

                // 글 목록 페이지로 리다이렉트
                ScriptHelper.ShowAlert(this, "성공", "게시글이 정상적으로 등록되었습니다. 이메일을 확인하세요.", "success", "successPost", hlList.NavigateUrl);
            }
        }


        [WebMethod]
        public static string ChangeToCorrectGrammer(string prompt)
        {
            prompt = $"너는 뛰어난 문법 교정 전문가야. 아래 글에서 잘못된 문법을 고쳐줘. 답변은 문법을 고친 글만 제시해줘. \n" + prompt;
            string message = GPTHelper.GetGPTResponse(prompt);
            return message;
        }


        private bool IsAjaxRequest()
        {
            return Request.Headers["X-Requested-With"] == "XMLHttpRequest";
        }
    }
}