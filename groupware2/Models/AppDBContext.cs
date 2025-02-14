using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
namespace groupware2.Models
{
    public class AppDBContext : DbContext
    {
        public AppDBContext() : base("name=groupware2") { }
        public DbSet<Post> Posts { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<Document> Documents { get; set; }
    }
}