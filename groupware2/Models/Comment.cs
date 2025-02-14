using System;
using System.ComponentModel.DataAnnotations;

namespace groupware2.Models
{
    public class Comment
    {
        [Key]
        public int Id { get; set; }
        public string Content { get; set; }
        public string AuthorName { get; set; }
        public string AuthorPassword { get; set; }
        public string AuthorEmail { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsRemove { get; set; }
        public int PostId { get; set; }  // 외래 키
    }
}
