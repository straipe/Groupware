using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;

namespace groupware2.Hubs
{
    public class DocumentHub : Hub
    {
        public Task JoinGroup(string groupName)
        {
            return Groups.Add(Context.ConnectionId, groupName);
        }

        public Task LeaveGroup(string groupName)
        {
            return Groups.Remove(Context.ConnectionId, groupName);
        }

        public void UpdateTitle(string groupName, string title)
        {
            Clients.OthersInGroup(groupName).ReceiveTitle(title);
        }

        public void UpdateContent(string groupName, string content)
        {
            Debug.WriteLine(content);
            Clients.OthersInGroup(groupName).ReceiveContent(content);
        }
    }
}