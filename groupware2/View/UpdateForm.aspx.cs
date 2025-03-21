using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using groupware2.Models;
using System.Net.Mail;
using System.Net;
using groupware2.Utils;
using groupware2.App_GlobalResources;


namespace groupware2
{
    public partial class UpdateForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                using (var context = new AppDBContext())
                {
                    int Id = int.Parse(Request.QueryString["Id"]);
                    LoadPost(Id);
                }
                hlList.NavigateUrl = SecurityHelper.VerifyAdmin(Page) ? "AdminList.aspx" : "List.aspx";
            }
        }

        private void LoadPost(int Id)
        {
            using (var context = new AppDBContext())
            {
                var post = context.Posts.FirstOrDefault(p => p.Id == Id);
                if (post != null)
                {
                    txtTitle.Text = HttpUtility.HtmlDecode(post.Title);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "AddContent",
                        "document.querySelector('#editor').innerHTML += '" + HttpUtility.HtmlDecode(post.Content).Replace("'","\\'")+"';", true);
                    txtAuthorName.Text = HttpUtility.HtmlDecode(post.AuthorName);
                    hasEditor.Checked = post.HasDocument;
                    if (SecurityHelper.VerifyAdmin(Page))
                    {
                        lblAuthorPassword.Text = "PIN";
                        lblAuthorPassword.Style.Add("font-size", "16px");
                        lblAuthorPassword.Style.Add("line-height", "22px");
                        pnlAdminOptions.Visible = true;
                    }
                }
                else
                {
                    ScriptHelper.ShowAlert(this, "경고", "해당 게시글을 찾을 수 없습니다.", "error", "getPostError", hlList.NavigateUrl);
                }
            }
        }
        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            string title = txtTitle.Text;
            string content = HttpUtility.UrlDecode(hiddenContent.Value);
            string authorPassword = txtAuthorPassword.Text;
            bool editorChecked = hasEditor.Checked;

            if (string.IsNullOrWhiteSpace(title) || string.IsNullOrWhiteSpace(content))
            {
                ScriptHelper.ShowAlert(this, "경고", "공백을 제외하고 제목과 내용을 입력해 주세요.", "warning", "failUpdatePost");
            } else
            {
                using (var context = new AppDBContext())
                {
                    int Id = int.Parse(Request.QueryString["Id"]);
                    var post = context.Posts.FirstOrDefault(p => p.Id == Id);
                    if (post != null)
                    {
                        if (SecurityHelper.VerifyAdmin(Page))
                        {
                            if (SecurityHelper.VerifyPIN(authorPassword))
                            {
                                // 조회된 게시글의 속성들을 변경
                                post.Title = HttpUtility.HtmlEncode(title);
                                post.Content = HttpUtility.HtmlEncode(content);

                                // 변경 사항을 데이터베이스에 저장
                                context.SaveChanges();

                                // 이메일 전송 로직 추가
                                try
                                {
                                    MailMessage mailMessage = MailHelper.CreatePostMailMessageByManager("수정", ddlEditReason.SelectedItem.Text, post.Title, post.Content);
                                    MailHelper.SendEmail(mailMessage, post.AuthorEmail);
                                }
                                catch (Exception ex)
                                {
                                    // 이메일 전송 실패 시 로그 처리 및 사용자 알림
                                    ScriptHelper.ShowAlert(this, "경고", "게시글이 수정되었지만, 이메일 전송에 실패했습니다. 관리자에게 문의하세요.", "error", "sendEmailFromManagerError", $"Detail.aspx?Id={Id}");
                                    Debug.WriteLine(ex);
                                    return;
                                }

                                // 글 목록 페이지로 리다이렉트
                                ScriptHelper.ShowAlert(this, "성공", "게시글이 정상적으로 수정되었습니다.", "success", "successUpdatePostByManager", hlList.NavigateUrl);
                            } else
                            {
                                ScriptHelper.ShowAlert(this, "경고", "잘못된 PIN를 입력했습니다.", "error", "notCorrectPIN");
                            }
                        }
                        else if (SecurityHelper.VerifyPassword(authorPassword, post.AuthorPassword))
                        {
                            // 조회된 게시글의 속성들을 변경
                            post.Title = HttpUtility.HtmlEncode(title);
                            post.Content = HttpUtility.HtmlEncode(content);
                            if(!post.HasDocument && editorChecked)
                            {
                                var document = context.Documents.FirstOrDefault(d => d.PostId == post.Id);
                                if (document == null)
                                {
                                    var newDocument = new Document
                                    {
                                        AuthorName = post.AuthorName,
                                        IsRemove = false,
                                        PostId = post.Id,
                                        CreatedAt = DateTime.Now
                                    };
                                    context.Documents.Add(newDocument);
                                }
                                else document.IsRemove = false;
                                post.HasDocument = true;
                            } else if(post.HasDocument && !editorChecked)
                            {
                                var document = context.Documents.FirstOrDefault(d => d.PostId == post.Id);
                                document.IsRemove = true;
                                post.HasDocument = false;
                            }
                            // 변경 사항을 데이터베이스에 저장
                            context.SaveChanges();

                            // 이메일 전송 로직 추가
                            try
                            {
                                MailMessage mailMessage = MailHelper.CreatePostMailMessageByUser("수정", title, content);
                                MailHelper.SendEmail(mailMessage, post.AuthorEmail);
                            }
                            catch (Exception ex)
                            {
                                // 이메일 전송 실패 시 로그 처리 및 사용자 알림
                                ScriptHelper.ShowAlert(this, "경고", "게시글이 수정되었지만, 이메일 전송에 실패했습니다. 관리자에게 문의하세요.", "error", "sendEmailFromUserError", $"Detail.aspx?Id={Id}");
                                Debug.WriteLine(ex);
                            }

                            // 글 목록 페이지로 리다이렉트
                            ScriptHelper.ShowAlert(this, "성공", "게시글이 정상적으로 수정되었습니다.", "success", "successUpdatePostByManager", hlList.NavigateUrl);
                        }
                        else
                        {
                            ScriptHelper.ShowAlert(this, "경고", "잘못된 비밀번호를 입력하셨습니다.", "error", "notCorrectPassword");
                        }
                    }
                    else
                    {
                        ScriptHelper.ShowAlert(this, "경고", "해당 게시글을 찾을 수 없습니다.", "error", "getPostError2");
                    }
                }
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }
    }
}