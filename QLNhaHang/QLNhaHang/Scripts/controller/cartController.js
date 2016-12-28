var cart = {
    init: function () {
        cart.regEvents();
    },
  
    regEvents: function () {
        $('.btn_trolaitrangchuajax').off('click').on('click', function () {
            window.location.href = "/Home";
        });

        $('#btn_DatHang').on('click', function () {
            window.location.href = "/GioHang1/DatHang"
        }
        );
        
            
        $('.txtQuantity').on('change', function () {
            var listProduct = $('.txtQuantity');
            var cartList = [];
            $.each(listProduct, function (i, item) {

                cartList.push({
                    SoLuong: $(item).val(),
                    ThucAn: {
                        ThucDonID: $(item).data('id')
                    }
                });

            });

            $.ajax({
                url: '/GioHang1/Update',
                data: { cartModel: JSON.stringify(cartList) },
                dataType: 'json',
                type: 'POST',
                success: function (res) {
                    if (res.status == true) {
                        window.location.href = "/GioHang1";
                    }
                }
            })
        });
        
       



        $('.btn_XoaTatCa').off('click').on('click', function () {


            $.ajax({
                url: '/GioHang1/XoaTatCa',
                dataType: 'json',
                type: 'POST',
                success: function (res) {
                    alert('Bạn đã xóa tất cả sản phẩm thành công.!');
                    if (res.status == true) {
                        window.location.href = "/GioHang1";
                    }
                }
            });
        });



        $('.btn-delete').off('click').on('click', function (e) {
            e.preventDefault();
            $.ajax({
                data: { id: $(this).data('id') },
                url: '/GioHang1/Xoa',
                dataType: 'json',
                type: 'POST',
                success: function (res) {
                    if (res.status == true) {
                        window.location.href = "/Giohang1/Index";
                    }
                }
            });
        });


        
        
    }
}
cart.init();