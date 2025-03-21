using System;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Web.UI.WebControls;
using groupware2.Utils;
using Microsoft.AspNet.SignalR;
using StackExchange.Redis;

namespace groupware2.Hubs
{
    public class DocumentHub : Hub
    {
        private readonly IDatabase _redis;
        public DocumentHub()
        {
            _redis = RedisManager.Connection.GetDatabase();
        }

        public Task JoinGroup(string groupName)
        {
            string key = $"Document:{groupName}";
            if(!_redis.HashExists(key, "count"))
            {
                _redis.HashSet(key, "count", 1);
                Debug.WriteLine($"현재 문서의 접속자 수:1");
                Clients.Caller.ReceiveView(1);
            } else
            {
                if (int.TryParse(_redis.HashGet(key, "count"), out int count))
                {
                    _redis.HashSet(key, "count", count + 1);
                    Debug.WriteLine($"현재 {groupName}번 문서의 접속자 수:{count + 1}");
                    Clients.Caller.ReceiveView(count + 1);
                    Clients.Group(groupName).ReceiveView(count + 1);
                }
                else Debug.WriteLine("RedisCountError: 잘못된 형식입니다. int로 변환할 수 없습니다.");
            }

            return Groups.Add(Context.ConnectionId, groupName);
        }

        public Task LeaveGroup(string groupName)
        {
            IDatabase redis = RedisManager.Connection.GetDatabase();
            string key = $"Document:{groupName}";
            if (int.TryParse(redis.HashGet(key, "count"), out int count))
            {
                if (count > 1)
                {
                    redis.HashSet(key, "count", count - 1);
                    Debug.WriteLine($"현재 문서의 접속자 수:{count - 1}");
                    Clients.OthersInGroup(groupName).ReceiveView(count - 1);
                }
                else
                {
                    redis.KeyDelete(key);
                    Debug.WriteLine($"현재 문서의 접속자 수:0");
                }
            }
            else Debug.WriteLine("RedisCountError: 잘못된 형식입니다. int로 변환할 수 없습니다.");


            return Groups.Remove(Context.ConnectionId, groupName);
        }

        public void UpdateTitle(string groupName, string title)
        {
            Debug.WriteLine($"전송받은 글 제목: {title}");
            Clients.OthersInGroup(groupName).ReceiveTitle(title);
        }

        public void UpdateContent(string groupName, string content)
        {
            Debug.WriteLine($"전송받은 글 내용: {content}");
            Clients.OthersInGroup(groupName).ReceiveContent(content);
        }
    }
}