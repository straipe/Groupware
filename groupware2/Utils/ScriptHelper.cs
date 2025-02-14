using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace groupware2.Utils
{
    public class ScriptHelper
    {
        public static void ShowAlert(Page page, string title, string message, string icon, string key, string redirectUrl = "")
        {
            string script = createScript(title, message, icon);
            if (!string.IsNullOrEmpty(redirectUrl))
            {
                script += $@".then((result) => {{ 
                    if(result.isConfirmed) {{
                        window.location.href='{redirectUrl}';
                    }}
                }})";
            }
            script += ";";
            ScriptManager.RegisterStartupScript(page, page.GetType(), key, script, true);
        }

        private static string createScript(string title, string text, string icon)
        {
            return $@"
                Swal.fire({{
                    title: '{title}',
                    text: '{text}',
                    icon: '{icon}',
                    confirmButtonText: '확인',
                    customClass: {{
                        confirmButton: 'blue-btn'
                    }}
                }})
            ";
        }
    }
}