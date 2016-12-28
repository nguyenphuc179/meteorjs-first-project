using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QLNhaHang.ViewModels
{
    public class GioHangModel
    {
        private List<GioHangItem> _items = new List<GioHangItem>();

        public List<GioHangItem> Items
        {
            get { return _items; }
        }

        public void Add(GioHangItem item)
        {
            var gioHangItem = _items.Find(p => p.ThucDon.ThucDonID == item.ThucDon.ThucDonID);
            if(gioHangItem == null)
            {
                _items.Add(item);
            }
            else
            {
                gioHangItem.SoLuong += item.SoLuong;
            }
        }

        public void Update(int id, short soLuong)
        {
            var gioHangItem = _items.Find(p => p.ThucDon.ThucDonID == id);
            gioHangItem.SoLuong = soLuong;
        }

        public void Delete(int id)
        {
            var gioHangItem = _items.Find(p => p.ThucDon.ThucDonID == id);
            _items.Remove(gioHangItem);
        }

        public int TongSoLuong()
        {
            int kq = 0;
            kq = _items.Sum(p => p.SoLuong);
            return kq;
        }

        public int TongTriGia()
        {
            int kq = 0;
            kq = _items.Sum(p => (p.SoLuong * p.ThucDon.DonGia));
            return kq;
        }

        public void Clear()
        {
            _items.Clear();
        }
    }
}