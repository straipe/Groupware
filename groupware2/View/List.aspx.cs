using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Web.UI;
using System.Web.UI.WebControls;
using groupware2.Models;
using groupware2.Utils;

namespace groupware2
{
    public partial class List : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["PageIndex"] = 0;
                Session["PostsPerPage"] = App_GlobalResources.Constants.PostsPerPage; // 페이지당 표시할 게시글 수
                using (var context = new AppDBContext())
                {
                    int pageSize = Convert.ToInt32(Session["PostsPerPage"]);

                    // 총 게시글 수와 페이지 크기(PageSize)로 총 페이지 수 계산
                    int totalPosts = -1;
                    totalPosts = context.Posts.Count(p => !p.IsRemove);
                    int totalPages = (int)Math.Ceiling((double)totalPosts / pageSize); // 총 페이지 수 계산
                    Session["TotalPages"] = totalPages;
                }
            }
            LoadPosts();
        }

        private void LoadPosts()
        {
            using (var context = new AppDBContext())
            {
                int pageIndex = Convert.ToInt32(Session["PageIndex"]);
                int pageSize = Convert.ToInt32(Session["PostsPerPage"]);
                Debug.WriteLine($"현재 PageIndex: {pageIndex}");
                List<Post> posts = new List<Post>();
                
                posts = context.Posts
                .Where(p => !p.IsRemove)
                .OrderByDescending(p => p.CreatedAt)
                .Skip(pageIndex * pageSize)
                .Take(pageSize)
                .ToList();
                
                GridView1.DataSource = posts;
                GridView1.DataBind();

                int PageNavSize = Convert.ToInt32(App_GlobalResources.Constants.PageSize);
                BtnPrevious.Enabled = pageIndex != 0;
                BtnPrevious.Visible = BtnPrevious.Enabled;
                BtnNext.Enabled = pageIndex != (int)Session["TotalPages"]-1;
                BtnNext.Visible = BtnNext.Enabled;
                GeneratePageNumbers();
            }
        }

        private void GeneratePageNumbers()
        {
            int totalPages = Session["TotalPages"] != null ? (int)Session["TotalPages"] : 0;
            int pageIndex = Session["PageIndex"] != null ? (int)Session["PageIndex"] : 0;
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
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "getPostPageError", script, true);
                }
            }
        }

        protected void BtnPrevious_Click(object sender, EventArgs e)
        {
            int pageIndex = (int)Session["PageIndex"];
            int PageNavSize = Convert.ToInt32(App_GlobalResources.Constants.PageSize);
            Session["PageIndex"] = Math.Max(pageIndex - PageNavSize, 0);
            Reload();
        }

        protected void BtnNext_Click(object sender, EventArgs e)
        {
            int pageIndex = (int)Session["PageIndex"];
            int PageNavSize = Convert.ToInt32(App_GlobalResources.Constants.PageSize);
            Session["PageIndex"] = Math.Min(pageIndex + PageNavSize, (int)Session["TotalPages"]-1);
            Reload();
        }

        protected void PageButton_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int pageIndex = Convert.ToInt32(btn.CommandArgument);
            Session["PageIndex"] = pageIndex;
            Debug.WriteLine($"변경: {pageIndex}");
            Reload();
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