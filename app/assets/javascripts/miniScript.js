$('.waiting').focusin(function(){
	$('.waiting').animate({width: '+=100px'},'fast');
	$('.hidden_buttons').show();
	$('.scroll ul li:nth-child(2) .waiting').css('margin-left','+=100px')
});
$('.waitingOpen').focusout(function(){
	$('.scroll ul li:nth-child(2) .waiting').css('margin-left','-=100px')
	$('.waiting').animate({height: '-=100px'},'fast');
	$('.hidden_buttons').hide();
});