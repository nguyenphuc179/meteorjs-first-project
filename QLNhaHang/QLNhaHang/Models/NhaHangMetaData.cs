using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PagedList;
using System.ComponentModel.DataAnnotations;
namespace QLNhaHang.Models
{
    [MetadataTypeAttribute(typeof(ThucDon.ThucDonMetaData))]
    public partial class ThucDon
    {
        internal sealed class ThucDonMetaData
        {
            [Display(Name="ID")]
            public int ThucDonID { get; set; }

            [Display(Name = "Tên thực đơn")]
            [Required(ErrorMessage= "{0} không được để trống!!")]
            [MaxLength(100,ErrorMessage = "{0} tối đa 100 kí tự.")]
            [MinLength(2, ErrorMessage = "{0} ít nhất 2 kí tự.")]
            public string TenThucDon { get; set; }

            [Display(Name = "Đơn giá")]
            [Required(ErrorMessage = "{0}  không được để trống!!")]
            [DisplayFormat(DataFormatString="{0:#,##0 VND}",ApplyFormatInEditMode= true)]
            [Range(1,1000000000,ErrorMessage = "{0} giá bán từ {1} tới {2}")]
            public int DonGia { get; set; }

            [Display(Name = "Khuyến mãi")]
            [Required(ErrorMessage = "{0}  không được để trống!!")]
            public int KhuyenMai { get; set; }

            [Display(Name = "Mô tả")]
            public string MoTa { get; set; }

            [Display(Name = "Hình")]
            public string Hinh { get; set; }

            [Display(Name = "Thuộc miền")]
            [Required(ErrorMessage = "{0}  không được để trống!!")]
            public short ThuocMien { get; set; }

            [Display(Name = "Ngày cập nhật")]
            [DataType(dataType: DataType.Date,ErrorMessage = "{0} không hợp lệ!!")]
            [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}",ApplyFormatInEditMode= true)]
            public System.DateTime NgayCapNhat { get; set; }

            [Display(Name = "Nhóm món")]
            [Required(ErrorMessage = "{0}  không được để trống!!")]
            public int NhomMonID { get; set; }

            [Display(Name = "Ngưng bán")]
            [Required(ErrorMessage = "{0} Tên không được để trống!!")]
            public bool NgungBan { get; set; }

            [Display(Name = "Bí danh")]
            public string BiDanh { get; set; }

            
        }
    }

    [MetadataTypeAttribute(typeof(NhomMon.NhomMonMetaData))]
    public partial class NhomMon
    {
        internal sealed class NhomMonMetaData
        {
            [Display(Name = "ID")]
            public int NhomMonID { get; set; }

            [Display(Name = "Tên Nhóm Món")]
            [Required(ErrorMessage = "{0}  không được để trống!!")]
            [MaxLength(100, ErrorMessage = "{0} tối đa 100 kí tự.")]
            [MinLength(10, ErrorMessage = "{0} ít nhất 10 kí tự.")]
            public string TenNhomMon { get; set; }

            [Display(Name = "Phân loại")]
            public int PhanLoaiID { get; set; }

            [Display(Name = "Bí danh")]
            public string BiDanh { get; set; }
        }
    }

    [MetadataTypeAttribute(typeof(PhanLoai.PhanLoaiMetaData))]
    public partial class PhanLoai
    {
        internal sealed class PhanLoaiMetaData
        {
            [Display(Name = "ID")]
            public int PhanLoaiID { get; set; }

            [Display(Name = "Tên")]
            [Required(ErrorMessage = "{0}  không được để trống!!")]
            [MaxLength(100, ErrorMessage = "{0} tối đa 100 kí tự.")]
            [MinLength(10, ErrorMessage = "{0} ít nhất 10 kí tự.")]
            public string TenPhanLoai { get; set; }

            [Display(Name = "Bí danh")]
            public string BiDanh { get; set; }
        }
    }

    [MetadataTypeAttribute(typeof(BaiViet.BaiVietMetaData))]
    public partial class BaiViet
    {
        internal sealed class BaiVietMetaData
        {
            [Display(Name = "ID")]
            public int BaiVietID { get; set; }

            [Display(Name = "Tựa đề bài viết")]
            [Required(ErrorMessage = "{0}  không được để trống!!")]
            [MaxLength(100, ErrorMessage = "{0} tối đa 100 kí tự.")]
            [MinLength(10, ErrorMessage = "{0} ít nhất 2 kí tự.")]
            public string TuaBaiViet { get; set; }

            [Display(Name = "Nội dung")]
            [Required(ErrorMessage = "{0}  không được để trống!!")]
            public string NoiDung { get; set; }

            [Display(Name = "Thể loại")]
            public int TheLoai { get; set; }

            [Display(Name = "Ảnh đại diện")]
            public string HinhDaiDien { get; set; }

            [Display(Name = "Ngày cập nhật")]
            [DataType(dataType: DataType.Date, ErrorMessage = "{0} không hợp lệ!!")]
            [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
            public System.DateTime NgayCapNhat { get; set; }

            [Display(Name = "Người dùng")]
            public int NguoiDungID { get; set; }

            [Display(Name = "Bí danh")]
            public string BiDanh { get; set; }
        }
    }

    [MetadataTypeAttribute(typeof(NguoiDung.NguoiDungMetaData))]
    public partial class NguoiDung
    {
        internal sealed class NguoiDungMetaData
        {
            [Display(Name = "ID")]
            public int NguoiDungID { get; set; }

            [Display(Name = "Tên đăng nhập")]
            [Required(ErrorMessage = "{0} không được để trống!!")]
            [MaxLength(20, ErrorMessage = "{0} tối đa 50 kí tự.")]
            [MinLength(6, ErrorMessage = "{0} ít nhất 6 kí tự.")]
            public string TenDangNhap { get; set; }

            [Display(Name = "Mật khẩu")]
            [Required(ErrorMessage = "{0} không được để trống!!")]
            [MaxLength(20, ErrorMessage = "{0} tối đa 50 kí tự.")]
            [MinLength(6, ErrorMessage = "{0} ít nhất 6 kí tự.")]
            [DataType(dataType:DataType.Password, ErrorMessage = "{0} không hợp lệ")]
            public string Matkhau { get; set; }

            [Display(Name = "Họ tên")]
            [Required(ErrorMessage = "{0} không được để trống!!")]
            [MaxLength(50, ErrorMessage = "{0} tối đa 50 kí tự.")]
            [MinLength(2, ErrorMessage = "{0} ít nhất 2 kí tự.")]
            public string HoTen { get; set; }

            [Display(Name = "Email")]
            [MaxLength(200, ErrorMessage = "{0} tối đa {1} ký tự")]
            [MinLength(6, ErrorMessage = "{0} tối thiểu {1} ký tự")]
            [DataType(dataType: DataType.EmailAddress, ErrorMessage = "{0} không hợp lệ")]
            public string Email { get; set; }
        }
    }



    [MetadataTypeAttribute(typeof(KhachHang.KhachHangMetaData))]
    public partial class KhachHang
    {
        internal sealed class KhachHangMetaData
        {
            [Display(Name = "ID")]
            public int KhachHangID { get; set; }

            [Display(Name = "Họ tên")]
            [Required(ErrorMessage = "{0} không được để trống!!")]
            [MaxLength(50, ErrorMessage = "{0} tối đa 50 kí tự.")]
            [MinLength(2, ErrorMessage = "{0} ít nhất 2 kí tự.")]
            public string HoTen { get; set; }


            //khóa
            //[Display(Name = "Địa chỉ")]
            //[Required(ErrorMessage = "{0} không được để trống!!")]
            //[MaxLength(50, ErrorMessage = "{0} tối đa 50 kí tự.")]
            //[MinLength(2, ErrorMessage = "{0} ít nhất 2 kí tự.")]
            //public string DiaChi { get; set; }


                // khóa
            //[Display(Name = "Điện thoại")]
            //[DataType(dataType: DataType.PhoneNumber)]
            //[StringLength(20, MinimumLength = 6, ErrorMessage = "{0} từ {2} đến {1} ký tự số")]
            //[Required(ErrorMessage = "{0} Điện thoại không được rổng !")]
            //[RegularExpression(@"\d{6,20}", ErrorMessage = "{0} phải nhập số (Tối đa 20 số)")]
            //public string DienThoai { get; set; }

            [Display(Name = "Tên đăng nhập")]
            [Required(ErrorMessage = "{0} không được để trống!!")]
            [MaxLength(50, ErrorMessage = "{0} tối đa 50 kí tự.")]
            [MinLength(2, ErrorMessage = "{0} ít nhất 2 kí tự.")]
            public string TenDangNhap { get; set; }

            [Display(Name = "Mật Khẩu")]
            [Required(ErrorMessage = "{0} không được để trống!!")]
            [MaxLength(200, ErrorMessage = "{0} tối đa 200 ký tự")]
            [MinLength(2, ErrorMessage = "{0} tối thiểu 2 ký tự")]
            public string MatKhau { get; set; }

            [Display(Name = "Ngày sinh")]
            [DataType(dataType: DataType.Date, ErrorMessage = "{0} không hợp lệ!!")]
            [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
            public System.DateTime NgaySinh { get; set; }


            [Display(Name = "Email")]
            [Required(ErrorMessage = "{0} không được để trống!!")]
            [MaxLength(200, ErrorMessage = "{0} tối đa 200 ký tự")]
            [MinLength(2, ErrorMessage = "{0} tối thiểu 2 ký tự")]
            [DataType(dataType: DataType.EmailAddress, ErrorMessage = "{0} không hợp lệ")]
            public string Email { get; set; }
            //public bool GioiTinh { get; set; }
            //public string Hinh { get; set; }

        }
    }

    [MetadataTypeAttribute(typeof(DatHang.DatHangMetaData))]
    public partial class DatHang
    {
        internal sealed class DatHangMetaData
        {
            [Display(Name = "Ghi Chú")]
       
            [MaxLength(500, ErrorMessage = "{0} tối đa 500 ký tự")]
            [MinLength(2, ErrorMessage = "{0} tối thiểu 2 ký tự")]
            public string GhiChu { get; set; }
        }
    }





}