using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QLNhaHang.Models
{
    public static class XuLyTien
    {
        public static string MoneyToString(this int money)
        {
            return money.ToString("##,###");
        }
    }
}