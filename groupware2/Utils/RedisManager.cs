using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using StackExchange.Redis;

namespace groupware2.Utils
{
    public class RedisManager
    {
        private static readonly Lazy<ConnectionMultiplexer> lazyConnection =
        new Lazy<ConnectionMultiplexer>(() => ConnectionMultiplexer.Connect("localhost, allowAdmin=true"));

        public static ConnectionMultiplexer Connection => lazyConnection.Value;
    
        public static bool IsLock(string key, int time)
        {
            string lockValue = Guid.NewGuid().ToString();
            TimeSpan expiry = TimeSpan.FromMilliseconds(time);
            var db = Connection.GetDatabase();
            return db.StringSet("lock:"+key, lockValue, expiry, When.NotExists);
        }
    }
}