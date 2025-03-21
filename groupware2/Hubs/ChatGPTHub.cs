using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using Microsoft.AspNet.SignalR;
using Markdig;
using groupware2.Utils;

namespace groupware2.Hubs
{
    public class ChatGPTHub : Hub
    {
        public void GetGPTResponse(string prompt)
        {
            string message = GPTHelper.GetGPTResponse(prompt);
            Clients.Caller.ReceiveAsync(message);
        }
    }
}