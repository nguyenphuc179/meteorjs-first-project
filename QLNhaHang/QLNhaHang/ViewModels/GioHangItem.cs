using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QLNhaHang.Models;
namespace QLNhaHang.ViewModels
{
    public class GioHangItem
    {
        public ThucDon ThucDon { get; set; }
        public short SoLuong { get; set; }
        public GioHangItem() { }
        public GioHangItem (ThucDon thucDon , short soLuong)
        {
            this.ThucDon = thucDon;
            this.SoLuong = soLuong;
        }

    }
}