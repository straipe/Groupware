using System.Diagnostics;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(groupware2.App_Start.Startup))]

namespace groupware2.App_Start
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
        }
    }
}