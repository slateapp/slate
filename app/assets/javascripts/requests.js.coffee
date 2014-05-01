# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('.create_request').on 'click', (event) ->
		event.preventDefault()
		$.post url

	dispatcher = new WebSocketRails(window.location.host + '/websocket');
		
	channel = dispatcher.subscribe 'requests'
	channel.bind 'new', (request) ->
		if($('#example').length)
			$('#example').append("<li>#{'request received'}</li>")

#request.description