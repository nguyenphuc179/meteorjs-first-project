//responsive menu
$("#menu-toggle").click(function(e) {
	e.preventDefault();
	$("#menu-wrapper").toggleClass("toggled");

	var flag = false;
	if ($('#menu-wrapper').css('padding-left') == '0px') {
		flag = true;
	}
	if (flag == true) {
		$("#menu-toggle i").addClass("fa-close");
		$("#menu-toggle i").removeClass("fa-reorder");
		//$('#wrapper').animate({'margin-left':'250px'},500);
		$('#wrapper').addClass('toggled');
		$('#logo').css('display','none');
	}
	else {
		$("#menu-toggle i").addClass("fa-reorder");
		$("#menu-toggle i").removeClass("fa-close");
		$('#wrapper').removeClass('toggled');
		//$('#wrapper').animate({'margin-left':'0'},500);
		$('#logo').css('display','block');
	}
});
//end responsive menu 

// top link toggle
$(window).load(function() {
	if($(window).width() <= 991) {
		$(document).click(function() {
			$('.top-links').hide();
		});
		$('#top_link_trigger').click(function(e) {
			e.preventDefault();
			e.stopPropagation();
			$('.top-links').toggle();
		});
	}
});
// end top link toggle

// change state of collapse arrow
$('.filter_group a').click(function() {
	$(this).find('i').toggleClass('fa fa-angle-down');
	$(this).find('i').toggleClass('fa fa-angle-right');
});
// end change state of collapse arrow

// mark the chosen color
$('.color_block').click(function() {
	$(this).parent().toggleClass('bordercolor');
});
// end mark the chosen color 

// scroll
//http://stackoverflow.com/questions/7717527/jquery-smooth-scrolling-when-clicking-an-anchor-link
$('.pagination li a').click(function() {scrollToShop(0)});

function scrollToShop(margin) {
	var locate = parseInt($('#content').offset().top) + margin;
	$('html, body').animate({
		scrollTop: locate
	},1000);
	return false;
}
// end scroll


//placeholder
/*$('input,textarea').focus(function(){
	$(this).data('placeholder',$(this).attr('placeholder'))
	.attr('placeholder','');
}).blur(function(){
	$(this).attr('placeholder',$(this).data('placeholder'));
});*/