using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace QLNhaHang.Models
{
    public class ContactModel
    {
        [Display(Name = "Tên của bạn")]
        [Required(ErrorMessage = "Tên không được trống")]
        public string UserName { get; set; }

        [Display(Name = "Email")]
        [Required(ErrorMessage = "Email không được trống")]
        [DataType(DataType.EmailAddress, ErrorMessage = "Email không đúng")]
        public string Email { get; set; }

        [Display(Name = "Chủ đề")]
        [Required(ErrorMessage = "Chủ đề không được trống")]
        public string Subject { get; set; }

        [Display(Name = "Nội dung")]
        [Required(ErrorMessage = "Nội dung không được trống")]
        [DataType(DataType.MultilineText)]
        public string Message { get; set; }
    }
}