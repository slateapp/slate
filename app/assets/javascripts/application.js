// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require websocket_rails/main
//= require_tree .
//= require bootstrap

var li = '';
$(document.body).on('click', '.del' ,function(){
    li = $(this).parent();
    $('#sterge').popup("open");
});

$(document.body).on('click', '#delButton' ,function(){
    $('#sterge').popup("close");
    li.remove();
});

$(document.body).on('click', '#giveupButton' ,function(){
    $('#sterge').popup("close");
});

$(document).ready(function(){
	// $('.alert').animate({ top: '-=100px' }, 600, 'easeInSine', function () {
		$('.alert').delay( 3000 ).fadeOut( 1000 );
	// })
});

