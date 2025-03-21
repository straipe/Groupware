using System;
using System.Diagnostics;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using System.Web;
using groupware2.App_GlobalResources;

namespace groupware2.Utils
{
    public class MailHelper
    {
        public static void SendEmail(MailMessage mailMessage, string recipientEmail)
        {
            // SMTP 클라이언트 설정
            SmtpClient smtpClient = new SmtpClient("smtp.gmail.com", 587)
            {
                Credentials = new NetworkCredential(Constants.AdminEmail, Constants.AdminAppPassword),
                EnableSsl = true
            };

            mailMessage.To.Add(recipientEmail);
            
            // 이메일 전송
            Task t = Task.Run(() => smtpClient.Send(mailMessage));
        }

        public static MailMessage CreatePostMailMessageByUser(string mode, string postTitle, string postContent)
        {
            // 이메일 메시지 작성
            MailMessage mailMessage = new MailMessage
            {
                From = new MailAddress(Constants.AdminEmail, "그룹게시판 관리자"),
                Subject = $"[그룹게시판] 회원님의 게시글이 성공적으로 {mode}되었습니다.",
                Body = CreatePostEmailBodyByUser(mode, postTitle, postContent),
                IsBodyHtml = true
            };
            return mailMessage;

        }

        public static MailMessage CreateCommentMailMessageByUser(string mode, string commentContent)
        {
            // 이메일 메시지 작성
            MailMessage mailMessage = new MailMessage
            {
                From = new MailAddress(Constants.AdminEmail, "그룹게시판 관리자"),
                Subject = $"[그룹게시판] 회원님의 댓글이 성공적으로 {mode}되었습니다.",
                Body = CreateCommentEmailBodyByUser(mode, commentContent),
                IsBodyHtml = true
            };
            return mailMessage;
        }

        public static MailMessage CreatePostMailMessageByManager(string mode, string why, string postTitle, string postContent)
        {
            // 이메일 메시지 작성
            MailMessage mailMessage = new MailMessage
            {
                From = new MailAddress(Constants.AdminEmail, "그룹게시판 관리자"),
                Subject = $"[그룹게시판] 회원님의 게시글이 관리자에 의해 {mode}되었습니다.",
                Body = CreatePostEmailBodyByManager(mode, why, postTitle, postContent),
                IsBodyHtml = true
            };
            return mailMessage;
        }

        public static MailMessage CreateCommentMailMessageByManager(string mode, string why, string commentContent)
        {
            // 이메일 메시지 작성
            MailMessage mailMessage = new MailMessage
            {
                From = new MailAddress(Constants.AdminEmail, "그룹게시판 관리자"),
                Subject = $"[그룹게시판] 회원님의 댓글이 관리자에 의해 {mode}되었습니다.",
                Body = CreateCommentEmailBodyByManager(mode, why, commentContent),
                IsBodyHtml = true
            };
            return mailMessage;
        }

        private static string CreatePostEmailBodyByUser(string mode, string postTitle, string postContent)
        {
            string content = $@"
                    <p>안녕하세요,</p>
                    <p>귀하의 게시글이 성공적으로 {mode}되었습니다.</p>
                    <hr>
                    <p><strong>제목:</strong> {postTitle}</p>
                    <br/>
                    <p><strong>내용:</strong></p>
                    <pre style='background-color: #f0f8ff; padding: 10px; border-radius: 5px;'>{ HttpUtility.HtmlDecode(postContent) }</pre>
                    <br/>
                    <p>추가 문의 사항이 있다면 관리자에게 연락해 주세요.</p>
                ";

            return CreateEmailBodyWithTemplate("게시글", mode, content);
        }

        private static string CreateCommentEmailBodyByUser(string mode, string commentContent)
        {
            string content = $@"
                    <p>안녕하세요,</p>
                    <p>귀하의 댓글이 성공적으로 {mode}되었습니다.</p>
                    <hr>
                    <p><strong>내용:</strong></p>
                    <pre style='background-color: #f0f8ff; padding: 10px; border-radius: 5px;'>{commentContent}</pre>
                    <br/>
                    <p>추가 문의 사항이 있다면 관리자에게 연락해 주세요.</p>
                ";

            return CreateEmailBodyWithTemplate("댓글", mode, content);
        }

        private static string CreatePostEmailBodyByManager(string mode, string why, string postTitle, string postContent)
        {
            string content = $@"
                    <p>안녕하세요,</p>
                    <p>귀하의 게시글이 다음과 같은 사유로 관리자에 의해 {mode}되었습니다.</p>
                    <br/>
                    <p><strong>사유:</strong> <span style='font-weight: bold; color: #0077cc;'>{why}</span></p>
                    <hr>
                    <p><strong>제목:</strong> {postTitle}</p>
                    <br/>
                    <p><strong>내용:</strong></p>
                    <pre style='background-color: #f0f8ff; padding: 10px; border-radius: 5px;'>{HttpUtility.HtmlDecode(postContent)}</pre>
                    <br/>
                    <p>추가 문의 사항이 있다면 관리자에게 연락해 주세요.</p>
                ";
            return CreateEmailBodyWithTemplate("게시글", mode, content);
        }

        private static string CreateCommentEmailBodyByManager(string mode, string why, string commentContent)
        {
            string content = $@"
                    <p>안녕하세요,</p>
                    <p>귀하의 댓글이 다음과 같은 사유로 관리자에 의해 {mode}되었습니다.</p>
                    <br/>
                    <p><strong>사유:</strong> <span style='font-weight: bold; color: #0077cc;'>{why}</span></p>
                    <hr>
                    <p><strong>내용:</strong></p>
                    <pre style='background-color: #f0f8ff; padding: 10px; border-radius: 5px;'>{commentContent}</pre>
                    <br/>
                    <p>추가 문의 사항이 있다면 관리자에게 연락해 주세요.</p>
                ";

            return CreateEmailBodyWithTemplate("댓글", mode, content);
        }

        private static string CreateEmailBodyWithTemplate(string kind, string action, string content)
        {
            return $@"
                <!DOCTYPE html>
                <html lang='ko'>
                <head>
                    <meta charset='UTF-8'>
                    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                    <title>{kind} {action} 알림</title>
                </head>
                <body style='font-family: Arial, sans-serif;
                            background-color: #f8f9fa;
                            color: #333;
                            margin: 0;
                            padding: 0;'>
                    <div style='max-width: 600px;
                            margin: 20px auto;
                            padding: 20px;
                            background-color: #ffffff;
                            border-radius: 8px;
                            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);'>
                        <div style='background-color: #c9efff;
                            padding: 15px;
                            text-align: center;
                            font-size: 20px;
                            font-weight: bold;
                            border-radius: 8px 8px 0 0;'>📢 {kind} {action} 안내</div>
                        <div style='padding: 20px;line-height: 1.6;'>"
                            + content +
                        $@"</div>
                        <div style='text-align: center;
                            padding: 10px;
                            font-size: 12px;
                            color: #666;'>
                            ⓒ 2025 게시판 운영팀 | 문의: <a href='mailto:{Constants.AdminEmail}'>{Constants.AdminEmail}</a>
                        </div>
                    </div>
                </body>
                </html>";
        }

        public static bool IsValidEmail(string email) {
            string pattern = @"^[^<>\(\)\[\],;:""\\ ]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$";
            Regex regex = new Regex(pattern);
            return regex.IsMatch(email);
        }
    }
}