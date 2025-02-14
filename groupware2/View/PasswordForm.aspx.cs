using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Runtime.Remoting.Contexts;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using groupware2.Models;
using groupware2.Utils;

namespace groupware2.View
{
    public partial class PasswordForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string mode = Request.QueryString["mode"];

                using (var context = new AppDBContext())
                {
                    if (mode == "delete")
                    {
                        btnSubmit.Text = "삭제";
                        btnSubmit.CssClass = "red-btn";
                    }
                    else if (mode == "restore")
                    {
                        btnSubmit.Text = "복원";
                        btnSubmit.CssClass = "sky-btn";
                    }
                    int Id = int.Parse(Request.QueryString["Id"]);
                    LoadPost(Id);
                }
                if (SecurityHelper.VerifyAdmin(Page))
                {
                    lblAuthorPassword.Text = "PIN";
                    lblAuthorPassword.Style.Add("font-size", "16px");
                    lblAuthorPassword.Style.Add("line-height", "22px");
                    if(mode=="delete") pnlAdminDeleteOptions.Visible = true;
                    else if(mode=="restore") pnlAdminRestoreOptions.Visible = true;
                    hlList.NavigateUrl = "AdminList.aspx";
                } else hlList.NavigateUrl = "List.aspx";


            }
        }

        private void LoadPost(int Id)
        {
            using (var context = new AppDBContext())
            {
                var post = context.Posts.FirstOrDefault(p => p.Id == Id);
                if (post != null)
                {
                    txtAuthorName.Text = HttpUtility.HtmlDecode(post.AuthorName);
                }
                else
                {
                    ScriptHelper.ShowAlert(this, "경고", "해당 게시글을 찾을 수 없습니다.", "error", "getPostError");
                }
            }
        }

        protected void Btn_Click(object sender, EventArgs e)
        {
            string authorPassword = txtAuthorPassword.Text;

            using (var context = new AppDBContext())
            {
                int Id = int.Parse(Request.QueryString["Id"]);
                var post = context.Posts.FirstOrDefault(p => p.Id == Id);
                bool IsCompleteRemove = false;
                if (post != null)
                {
                    if(SecurityHelper.VerifyAdmin(Page))
                    {
                        if (SecurityHelper.VerifyPIN(authorPassword))
                        {
                            string mode = Request.QueryString["mode"];
                            string keyword = "제출";
                            if (mode == "delete")
                            {
                                keyword = "삭제";
                                if (post.IsRemove)
                                {
                                    context.Posts.Remove(post);
                                    IsCompleteRemove = true;
                                }
                                else
                                {
                                    post.IsRemove = true;
                                    var comments = context.Comments.Where(c => c.PostId == Id).ToList();
                                    
                                    foreach (var comment in comments)
                                    {
                                        comment.IsRemove = true;
                                    }
                                    if (post.HasDocument)
                                    {
                                        var document = context.Documents.FirstOrDefault(d => d.PostId == Id);
                                        document.IsRemove = true;
                                    }
                                }
                                context.SaveChanges();
                            }
                            else if (mode == "restore")
                            {
                                keyword = "복원";
                                post.IsRemove = false;
                                var comments = context.Comments.Where(c => c.PostId == Id).ToList();

                                foreach (var comment in comments)
                                {
                                    comment.IsRemove = false;
                                }

                                if (post.HasDocument)
                                {
                                    var document = context.Documents.FirstOrDefault(d => d.PostId == Id);
                                    document.IsRemove = false;
                                }

                                context.SaveChanges();
                            }

                            // 이메일 전송 로직 추가
                            if (!IsCompleteRemove)
                            {
                                try
                                {
                                    string reason = mode == "delete" ? ddlDeleteReason.SelectedItem.Text : ddlRestoreReason.SelectedItem.Text;
                                    MailMessage mailMessage = MailHelper.CreatePostMailMessageByManager(keyword, reason, post.Title, post.Content);
                                    MailHelper.SendEmail(mailMessage, post.AuthorEmail);
                                }
                                catch (Exception ex)
                                {
                                    // 이메일 전송 실패 시 로그 처리 및 사용자 알림
                                    ScriptHelper.ShowAlert(this, "경고", "게시글이 수정되었지만, 이메일 전송에 실패했습니다.", "error", "sendEmailFromManagerByUpdateError", $"Detail.aspx?Id={Id}");
                                    Debug.WriteLine(ex);
                                    return;
                                }
                            }
                            // 글 목록 페이지로 리다이렉트
                            ScriptHelper.ShowAlert(this, "성공", $"게시글이 정상적으로 {keyword}되었습니다.", "success", "successSubmitPost", hlList.NavigateUrl);
                        } else
                        {
                            ScriptHelper.ShowAlert(this, "경고", "잘못된 PIN를 입력했습니다.", "error", "notCorrectPIN");
                        }
                    }
                    else if (SecurityHelper.VerifyPassword(authorPassword, post.AuthorPassword))
                    {
                        string mode = Request.QueryString["mode"];
                        if(mode == "delete")
                        {
                            post.IsRemove = true;
                            var comments = context.Comments.Where(c => c.PostId == Id).ToList();

                            foreach (var comment in comments)
                            {
                                comment.IsRemove = true;
                            }

                            if (post.HasDocument)
                            {
                                var document = context.Documents.FirstOrDefault(d => d.PostId == Id);
                                document.IsRemove = true;
                            }

                            // 변경 사항을 데이터베이스에 저장
                            context.SaveChanges();

                            // 이메일 전송 로직 추가
                            try
                            {
                                MailMessage mailMessage = MailHelper.CreatePostMailMessageByUser("삭제", post.Title, post.Content);
                                MailHelper.SendEmail(mailMessage, post.AuthorEmail);
                            }
                            catch (Exception ex)
                            {
                                // 이메일 전송 실패 시 로그 처리 및 사용자 알림
                                ScriptHelper.ShowAlert(this, "경고", "게시글이 삭제되었지만, 이메일 전송에 실패했습니다.", "error", "sendEmailFromManagerByDeleteError", hlList.NavigateUrl);
                                Debug.WriteLine(ex);
                                return;
                            }

                            // 글 목록 페이지로 리다이렉트
                            ScriptHelper.ShowAlert(this, "성공", "게시글이 정상적으로 삭제되었습니다. 이메일을 확인하세요.", "success", "successDeletePost", hlList.NavigateUrl);
                        }
                    }
                    else
                    {
                        ScriptHelper.ShowAlert(this, "경고", "잘못된 비밀번호를 입력했습니다.", "error", "notCorrectPassword");
                    }
                }
                else
                {
                    ScriptHelper.ShowAlert(this, "경고", "해당 게시글을 찾을 수 없습니다.'", "error", "getPostErrorForDelete");
                }
            }
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
    }
}