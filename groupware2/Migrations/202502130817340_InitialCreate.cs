namespace groupware2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Comments",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Content = c.String(),
                        AuthorName = c.String(),
                        AuthorPassword = c.String(),
                        AuthorEmail = c.String(),
                        CreatedAt = c.DateTime(nullable: false),
                        IsRemove = c.Boolean(nullable: false),
                        PostId = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Documents",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Title = c.String(),
                        Content = c.String(),
                        AuthorName = c.String(),
                        IsRemove = c.Boolean(nullable: false),
                        PostId = c.Int(nullable: false),
                        CreatedAt = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Posts",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Title = c.String(),
                        Content = c.String(),
                        AuthorName = c.String(),
                        AuthorPassword = c.String(),
                        AuthorEmail = c.String(),
                        IsRemove = c.Boolean(nullable: false),
                        HasDocument = c.Boolean(nullable: false),
                        CreatedAt = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Posts");
            DropTable("dbo.Documents");
            DropTable("dbo.Comments");
        }
    }
}
