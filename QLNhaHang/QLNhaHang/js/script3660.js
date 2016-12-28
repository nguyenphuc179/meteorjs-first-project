//get_viewed_items_html...  
function get_viewed_items_html($current_product)
{
	// saving current viewed-item 
	var jsonProducts = sessionStorage.getItem('products_viewed'); 
	var arrPro = {}; 
	if( jsonProducts != null  ) 
		arrPro = JSON.parse( jsonProducts );  
	else
	{
		sessionStorage.removeItem('products_viewed'); 
		sessionStorage.removeItem('products_viewed_indexing'); // must-have this LOC 
	}

	// var $current_product = ; // $current_product object, ko phải string...   
	if($current_product != null && arrPro[$current_product.id] == null) // null / undefined 
	{ 
		arrPro[$current_product.id] = $current_product;   
		sessionStorage.setItem('products_viewed', JSON.stringify( arrPro ));  // 


		// saving current index 
		var jsonProIndex = sessionStorage.getItem('products_viewed_indexing'); 

		var arrProIndex = []; 
		if( jsonProIndex != null )  
			arrProIndex = JSON.parse( jsonProIndex );  
		arrProIndex.push($current_product.id);  
		sessionStorage.setItem('products_viewed_indexing', JSON.stringify( arrProIndex ));  // 

	}


	var jsonProIndex = sessionStorage.getItem('products_viewed_indexing'); 
	var jsonProducts = sessionStorage.getItem('products_viewed'); 
	var arrProIndex = []; 
	var $strHTML = ''; 
	var $countViewedItem = 0; 
	var $intMaxViewedItems = ''; 
	if($intMaxViewedItems == '')
		$intMaxViewedItems = 3; 
	else 
		$intMaxViewedItems = parseInt($intMaxViewedItems); 
	if(jsonProIndex != null & jsonProducts != null & $current_product != null )
	{
		//parse indexing, products...  
		arrProIndex = JSON.parse(jsonProIndex);   
		arrPro = JSON.parse( jsonProducts );   

		// assign count_items = 0;
		for (i=0; i<arrProIndex.length; i++ )
		{

			$strProID = arrProIndex[i];  
			if( $current_product.id != $strProID && $strProID != null && $countViewedItem < $intMaxViewedItems)
			{ 

				var product_viewed = arrPro[$strProID];
				//console.log(product_viewed);
				var price = Bizweb.formatMoney(product_viewed.price, "") + '' + ' đ</b>'; 
				var compare_price = Bizweb.formatMoney(product_viewed.compare_at_price, "") + '' + ' đ</b>'; 
				var old_price = '';
				if (product_viewed.price < product_viewed.compare_at_price) {
					old_price = '<del>'+compare_price+'</del>';
				}
				// for (img_idx ; i<product_viewed.images.length; img_idx++) 

				$bo_found = true;  
				//product_viewed['images'][0]; 
				//==JSON.parse(localStorage.getItem('products_viewed'))['1000302443']['images'][0]		
				$strHTML += '<div class="spost clearfix"> <div class="entry-image">'
				+'<a href="'+ product_viewed.alias + '" title="'+ product_viewed.name + '">'  
				+' <img' 
				+ ' u="image" '
				+' src="'+ product_viewed['images'][0].src + '"'
				+' alt="'+ product_viewed.name + '"'
				+ ' data-big="'+ product_viewed['images'][0] + '"'
				+' data-title="'+ product_viewed.name + '"'
				+' data-description="'+ product_viewed.name + '"'
				// +'data_shape_color_code="'+ str_shape_color + '"' 
				// +'data_shape_code="'+ arrName[0] + '"' 
				// +'data_color_code="'+ arrName[1] + '" 
				+'/>' 
				+'</a>'
				+'</div>'
				+'<div class="entry-c">'
				+'<div class="entry-title">'
				+'<h4><a href="'+ product_viewed.alias +'">'+ product_viewed.name +'</a></h4>'
				+'</div>'
				+'<ul class="entry-meta"><li class="color">'+ old_price +'<ins> '+price+'</ins></li></ul>'

				+'</div></div>'

				// console.log($strHTML);

				$countViewedItem = $countViewedItem + 1; 

			} //  
		} // endfor: arrProIndex   
	} // endif: jsonProIndex

	return $strHTML; 
}// get_vied_items_html


/*** add to cart ***/
/*
jQuery(document).ready(function(){
	// BEGIN EGANY Custom
	$("span.filterToggle").click(function(){
		var parent = $(this).parent();
		var dropdown_checkbox = parent.find("ul.dropdown-menu");
		var icon_left = parent.find("i.icon-left");
		if (icon_left.hasClass("fa-caret-down")) {
			icon_left.removeClass("fa-caret-down");
			icon_left.addClass("fa-caret-right");
		}
		else{
			icon_left.removeClass("fa-caret-right");
			icon_left.addClass("fa-caret-down");
		}
		dropdown_checkbox.slideToggle('easing');
	});
	// END EGANY Custom
});
*/

// <<<<<< product BEGIN  
function refreshProductSelections($tagSelectOption0, $option0, $tagSelectOption1 , $option1, $tagSelectOption2, $option2) 
{
	if($option0 != null && $option0 != '')
	{ 	
		//change option 0  
		$($tagSelectOption0 + ' option[value="'+$option0+'"]').prop('selected', true); // option-0 => Shape...  okok 
		$($tagSelectOption0).change(); 
	}


	if($option1 != null && $option1 != '')
	{ 
		//change option 1  
		$($tagSelectOption1 + ' option[value="'+$option1+'"]').prop('selected', true); // option-1 => Color...  okok 
		$($tagSelectOption1).change();  
	}
	if($option2 != null && $option2 != '')
	{ 
		//change option 2
		$($tagSelectOption2 + ' option[value="'+$option2+'"]').prop('selected', true); // option-1 => Color...  okok 
		$($tagSelectOption2).change();  
	}
}

function update_variant(variant, $tagPrice, $tagPriceCompare, $tagAddToCart, $tagProductSection,$sale) 
{
	var $unit_price = 0; 
	var $unit_price_compare = 0; 
	if(variant != null && variant.available==true )
	{ 
		$unit_price = variant.price;
		if(variant.price < variant.compare_at_price){
			$unit_price_compare = variant.compare_at_price;  
			var $percent = (100*($unit_price_compare - $unit_price)/$unit_price_compare);
			$percent = Math.ceil($percent);
			//show onsale label
			$($sale).removeClass('hidden');  
			$($sale).html('-'+$percent+'%');  
			
		} else{

			//hide onsale label... nono: find matching ids: ('[id^="ProductDetails"]')  
			$($sale).addClass('hidden');  
		}
		
		$($tagAddToCart).html('Thêm vào giỏ'); 
		$($tagAddToCart).removeAttr('disabled');  
	}   
	else{

		$($tagAddToCart).html('Hết hàng'); 
		$($tagAddToCart).prop('disabled', true); 
	}

	var $strUnitPrice = Bizweb.formatMoney($unit_price, '');  // ''  shop.money_format
	console.log(Bizweb.formatMoney(variant.price, ""));
	var $strUnitPriceCompare = Bizweb.formatMoney($unit_price_compare, '');  // ''  shop.money_format
	$($tagPrice).html($strUnitPrice); 
	if($unit_price_compare > 0)
	{
		$($tagPriceCompare).html($strUnitPriceCompare);   
	}
	else 
		$($tagPriceCompare).html('');   

	$($tagProductSection).find('.unit_price_not_formated').val($unit_price);    
	// update_total();
}

//ajax: add to cart 
function addItem(form_id, fly_img) {
	$.ajax({
		type: 'POST',
		url: '/cart/add.js',
		dataType: 'json',
		data: $('#'+form_id).serialize(),
		success: Bizweb.onSuccess(fly_img, '#'+form_id),
		error: Bizweb.onError
	});
}

Bizweb.onSuccess = function(fly_img, form_id) { 
	flyToElement($(fly_img), $('.top-cart-block')); 

	//update top cart: qty, total price
	var $product_page = $(form_id).parents('[class^="product-page"]'); 
	var quantity = parseInt($product_page.find('[name="quantity"]').val(), 10) || 1;
	var $item_qty_new = 0; 
	var $item_price_new = 0; 
	var $item_price_increase = 0; 
	var $boUpdated = false; 

	//insert "no_item" html  
	if($('.top-cart-block .top-cart-content .top-cart-item').size() <= 0) 
	{
		$('.top-cart-block .top-cart-content').html(top_cart_no_item);  
	} 
	//update items 
	$('.top-cart-block .top-cart-content .top-cart-item').each(function(){	
		if($(this).find('.item_id').val() == $product_page.find('[name="id"]').val() ){
			$item_qty_new = parseInt($(this).find('.item_qty').val()) + quantity ;
			$item_price_single = parseFloat($(this).find('.item_unit_price_not_formated').val());
			$item_price_new = $item_qty_new * $item_price_single;   

			$item_price_increase = quantity * parseFloat($(this).find('.item_unit_price_not_formated').val());   
			$(this).find('.item_qty').val($item_qty_new);  // !!!
			$(this).find('.top-cart-item-quantity').html('x ' + $item_qty_new); 
			$(this).find('.top-cart-item-price').html(Bizweb.formatMoney($item_price_new, "") + 'đ');  // ''  shop.money_format
			$boUpdated = true; // updated item 
		} 
	});

	if($boUpdated == false){ // current item is not existed!!!  
		var $proURL = $product_page.find('.product_url').val();
		var $proTitle = $product_page.find('.product_title_hd').val();
		var $proUnitPrice = parseFloat($product_page.find('.unit_price_not_formated').val());
		var $strNewItem = '<div class="top-cart-item clearfix">'
		+ ' <input type="hidden" class="item_id" value="'+ $product_page.find('[name="id"]').val() +'"></input>'  
		+ ' <input type="hidden" class="item_qty" value="'+ quantity +'"></input>' 
		+ ' <input type="hidden" class="item_unit_price_not_formated" value="'+ $proUnitPrice +'"></input>' 

		+ '<div class="top-cart-item-image">'
		+ ' <a href="'+ $proURL +'"><img src="'+ $product_page.find('.product_img_small').val() +'" alt="'+ $proTitle +'" ></a>'
		+ '</div>'
		+ '<div class="top-cart-item-desc">'
		//+ ' <span class="cart-content-count">x'+ quantity +'</span>'
		+ '<a href="'+ $proURL +'">' + $proTitle + '</a>'
		+ '<span class="top-cart-item-price">'+ Bizweb.formatMoney($proUnitPrice * quantity, "") + 'đ' +'</span>' 
		+ '<span class="top-cart-item-quantity">x '+ quantity +'</span>'
		+ ' </div>'
		+ '</div>';
		$('.top-cart-block .top-cart-content .top-cart-items').append($strNewItem); 
		$item_price_increase = $proUnitPrice * quantity; 

	}  
	//check is emptiness...   
	check_topcart_empty();  

	//update total 
	var $quantity_new = parseInt($('.top-cart-block #top-cart-trigger span').text()) + quantity;  
	var $price_new = parseFloat($('.top-cart-block .top_cart_total_price_not_format').val()) + $item_price_increase;  
	$('.top-cart-block .top_cart_total_price_not_format').val($price_new);  // !!!
	$('.top-cart-block #top-cart-trigger span').html($quantity_new); 
	$('.top-cart-block .top-checkout-price').html(Bizweb.formatMoney($price_new, "") + 'đ'); 	

};
// Bizweb.onError = function(XMLHttpRequest, textStatus) { 
// }; 
// Bizweb.fullMessagesFromErrors = function(errors) { 
// };

var top_cart_empty = '<div style = "text-align: center"> Chưa có sản phẩm trong giỏ!</div>';  
var top_cart_no_item = ''; 
function check_topcart_empty(){  

	//Bạn chưa mua sản phẩm nào! 
	if($('.top-cart-block .top-cart-content .top-cart-item').size() <= 0) 
	{		
		top_cart_no_item = $('.top-cart-block .top-cart-content').html();   
		$('.top-cart-block .top-cart-content').html(top_cart_empty); 
		$('.top-cart-block .top-cart-content').css('width', '200px'); 
	}
	else{
		//remove width, okok!!! 
		$('.top-cart-block .top-cart-content').css('width', '');
	}
}
jQuery(document).ready(function($){

	//select first size&color. 
	//second item: $($("#colorPicker option").get(1))...  
	$("#sizePicker option:first").attr('selected', 'selected'); 
	$("#colorPicker option:first").attr('selected', 'selected'); 

	// function: choose size  
	$('#option-0 select').change(function(){
		var $size = $(this).val(); 
		var $color = $('#option-1 select').val();
		var $material	= $('#option-2 select').val();
		var $tagSelectOption0 = '#product-select-option-0'; 
		var $tagSelectOption1 = '#product-select-option-1'; 
		var $tagSelectOption2 = '#product-select-option-2'; 

		refreshProductSelections($tagSelectOption0, $size, $tagSelectOption1 , $color,$tagSelectOption2 , $material);
	});

	// function: choose color  
	$('#option-1 select').change(function(){
		var $size = $('#option-0 select').val(); 
		var $color = $(this).val();
		var $material	= $('#option-2 select').val();  
		var $tagSelectOption0 = '#product-select-option-0'; 
		var $tagSelectOption1 = '#product-select-option-1'; 
		var $tagSelectOption2 = '#product-select-option-2'; 

		refreshProductSelections($tagSelectOption0, $size, $tagSelectOption1 , $color,$tagSelectOption2 , $material);
	});

	// function: choose material
	$('#option-2 select').change(function(){
		var $size = $('#option-0 select').val(); 
		var $color = $('#option-1 select').val();
		var $material = $(this).val();  
		var $tagSelectOption0 = '#product-select-option-0'; 
		var $tagSelectOption1 = '#product-select-option-1'; 
		var $tagSelectOption2 = '#product-select-option-2'; 

		refreshProductSelections($tagSelectOption0, $size, $tagSelectOption1 , $color,$tagSelectOption2 , $material);
	});

	$("#option-0 select option:first").attr('selected', 'selected'); 
	$("#option-1 select option:first").attr('selected', 'selected'); 
	$("#option-2 select option:first").attr('selected', 'selected'); 
	var $size = $("#option-0 select option:first").val(); 
	var $color = $("#option-1 select option:first").val();
	var $material	= $("#option-2 select option:first").val();
	var $tagSelectOption0 = '#product-select-option-0'; 
	var $tagSelectOption1 = '#product-select-option-1'; 
	var $tagSelectOption2 = '#product-select-option-2'; 

	refreshProductSelections($tagSelectOption0, $size, $tagSelectOption1 , $color,$tagSelectOption2 , $material);


	//add to cart 
	$("#addtocart").on('click', function(e) {  //.click(function(e){ // 

		e.preventDefault();
		addItem('ProductDetailsForm', '.product-main-image .slider-wrap img');

	}); 

	//add to cart for QuickView
	$("#addtocartQV").on('click', function(e) {  //.click(function(e){ // 

		e.preventDefault();
		addItem('ProductDetailsFormQV', '#product-pop-up .product-main-image img');

	}); 

	//check empty for top-cart... 
	check_topcart_empty(); 

	//change qty... 
	$('.product-quantity input.quantity').on('change', function(){
		var $qty = parseInt($(this).val()); 
		if($qty <= 0){
			$(this).parents('[class^="product-page"]').find('[id^="addtocart"]').addClass('disabled'); 
		}
		else{ 
			$(this).parents('[class^="product-page"]').find('[id^="addtocart"]').removeClass('disabled'); 
		}
	});


// buy now
$('#buynow').on('click', function(e) {
	var form = $(this).closest('form').attr('id');
	e.preventDefault();
	var params = {
		type: 'POST',
		url: '/cart/add.js', 
		data: jQuery('#'+form).serialize(),
		dataType: 'json',
		success: function() {
			window.location = '/checkout';
		},
		error: function(XMLHttpRequest, textStatus) {
			Bizweb.onError(XMLHttpRequest, textStatus);
		}
	};
	jQuery.ajax(params);
});
// end buy now

});  

// >>>>>> product END