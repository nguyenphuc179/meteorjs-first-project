$('.MiniDetail').on('click', function () {
    $('#productModal').modal('show');
    var Malk = $(this).data('id');
    $.ajax({
        url: '/LinhKien/MiniDetail',
        data: { id: Malk },        
        type: 'GET',
        dataType: 'json',        
        success: function (res) {
            if (res.status == true) {                
                var data = res.data;
                $('#TenLK').text(data.TenLK);
                $('#Gia').text(data.Giaban);
                if (data.Soluongton > 0) { $('#ConHang').show() } else { $('#HetHang').show() }
                $('#Image').html('<img src="/ImagesProduct/' + data.Anhbia + '" width="380" />');
                $('#MaLK').val(data.MaLK);
                $('#Mota').html(decodeURI(data.Mota));
            }
            else {
                alert('lỗi');
            }
        }
    })

});