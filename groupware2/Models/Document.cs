using System;
using System.ComponentModel.DataAnnotations;

namespace groupware2.Models
{
    public class Document
    {
        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public string AuthorName { get; set; }
        public bool IsRemove { get; set; }
        public int PostId { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}