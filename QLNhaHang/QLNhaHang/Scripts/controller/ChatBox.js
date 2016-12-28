//--------ChatBox 
if (localStorage.getItem("fbchatclose") == 1) {
    jQuery('#chatfb').hide();    
    jQuery('#closefbchat').html('<i class="fa fa-comments fa-2x"></i> Nhắn tin cho chúng tôi').css({ 'bottom': 0 });
}
jQuery('#closefbchat').click(function () {
    jQuery('#chatfb').toggle('hide');    
    if (localStorage.getItem("fbchatclose") == 0 || localStorage.getItem("fbchatclose")==null) {
        localStorage.setItem("fbchatclose", 1);
        jQuery('#closefbchat').html('<i class="fa fa-comments fa-2x"></i> Nhắn tin cho chúng tôi').css({ 'bottom': 0 });
    }
    else {
        localStorage.setItem("fbchatclose", 0);
        jQuery('#closefbchat').text('Tắt').css({ 'bottom': 299 });
    }
});
//--------ChatBox