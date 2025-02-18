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
    }
}