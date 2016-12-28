jQuery(document).ready(function ($) {
    //selector đến menu cần làm việc
    var TopFixMenu = $("#fixNav");
    // dùng sự kiện cuộn chuột để bắt thông tin đã cuộn được chiều dài là bao nhiêu.
    $(window).scroll(function () {
        //kiểm tra xem chiều rộng hiển thị của máy tính hay điện thoại >800 là của máy tính
        if($(this).width()>800)
            {
        // Nếu cuộn được hơn 200px rồi
        if ($(this).scrollTop() > 200) {
            // Tiến hành show menu ra  
            $('#box_search_quick').addClass('search-fix')
            TopFixMenu.show();
        } else {
            // Ngược lại, nhỏ hơn 150px thì hide menu đi.
            TopFixMenu.hide();
            $('#box_search_quick').removeClass('search-fix')
        }
        }
        else
        {
            if ($(this).scrollTop() > 320) {
                // Tiến hành show menu ra    
                TopFixMenu.show();
                $('#box_search_quick').removeClass('search-mobi')
                $('#box_search_quick').addClass('search-fix-mobi')
            } else {
                // Ngược lại, nhỏ hơn 150px thì hide menu đi.
                TopFixMenu.hide();
                $('#box_search_quick').removeClass('search-fix-mobi')
                $('#box_search_quick').addClass('search-mobi')
            }
        }
    }
    )
})