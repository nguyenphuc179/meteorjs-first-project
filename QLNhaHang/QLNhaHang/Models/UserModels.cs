using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QLNhaHang.Models
{

    public class UserModels
    {
        public int? Id { get; set; }
        public string Fullname { get; set; }
      
    }
    public class ThucDon1
    {
        public int? MaMon { get; set; }
        public string TenMon { get; set; }

    }


    public class search
    {
        public int value { get; set; }
        public string label { get; set; }
        public string img { get; set; }
    }

    public class BienTamDatHang  
    {
        public  int ? TongTienMua { get; set; }
        public  int ? DemSoLuongMua { get; set; }
        public  int ? TongSoLuongMua { get; set; }
        //public DatHangCT DatHangChiTiet { get; set; }
        public  string TenMonAn { get; set; }
    }

    public class DetailChecktime
    {

      
        public DateTime HourIn { get; set; }
        public DateTime HourOut { get; set; }
    }



    public class CheckTimeSearchModels 
    {
        public int? Id { get; set; }
        public string Fullname { get; set; }
        public string Phone { get; set; }
        public string Username { get; set; }
    }


    public class ListThucDon
    {
        public  List<string> _ThucDon { get; set; }
        public  List<DatHangCT> ThucDon { get; set; }
        public int DatHangID { get; set; }
        public int  KhachHangID { get; set; }
        public decimal? TriGia { get; set; }
        public int?  DemSoLuong { get; set; }
        public int?  TongSoLuongMua { get; set; }


    }

}