using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using Markdig;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace groupware2.Utils
{
    public class GPTHelper
    {
        public static string GetGPTResponse(string prompt)
        {
            using (HttpClient client = new HttpClient())
            {
                string url = Environment.GetEnvironmentVariable("GPT_API_URL");
                var requestData = new
                {
                    messages = new[]
                    {
                        new { role="user", content = prompt }
                    },
                    max_tokens = 100,
                    temperature = 1
                };

                string jsonBody = JsonConvert.SerializeObject(requestData);
                var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", Environment.GetEnvironmentVariable("GPT_API_KEY"));
                client.DefaultRequestHeaders.Add("application", Environment.GetEnvironmentVariable("GPT_APPLICATION_NAME"));
                client.DefaultRequestHeaders.Add("compCode", Environment.GetEnvironmentVariable("GPT_COMP_CODE"));
                HttpResponseMessage response = client.PostAsync(url, content).Result;
                string message = null;
                if (response.IsSuccessStatusCode)
                {
                    string jsonString = response.Content.ReadAsStringAsync().Result;

                    JObject jsonObj = JObject.Parse(jsonString);
                    message = jsonObj["choices"]?[0]?["message"]?["content"].ToString();
                }
                else
                {
                    Debug.WriteLine($"Error: {response.StatusCode}");
                    Debug.WriteLine(response);

                }
                if (message == null) message = "응답을 불러오지 못했습니다. 관리자에게 문의해주세요.";
                message = Markdown.ToHtml(message);
                return message;
            }
        }
    }
}