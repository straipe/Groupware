using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace groupware2.Models
{
    public class Post
    {
        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public string AuthorName { get; set; }
        public string AuthorPassword { get; set; }  // 수정/삭제할 때 필요한 비밀번호
        public string AuthorEmail { get; set; }
        public bool IsRemove { get; set; }
        public bool HasDocument { get; set; }
        public int Views {  get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
