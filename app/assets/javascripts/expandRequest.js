//<![CDATA[ 
$(window).load(function(){
$('.li').hover(function() {
    $(this).animate({
        width: 215, height: 350, margin: 0,
    }, 'fast');
/*	$(this).animate().css('box-shadow', '0 0 10px #44f')*/
	$(this).animate().css('box-shadow', '0 0 5px #000')
	
}, function() {
	$(this).animate().css('box-shadow', 'none')
    $(this).animate({
        width: 210, height: 240, margin: 0,
    }, 'fast');
});
});//]]> 