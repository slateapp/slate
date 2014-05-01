# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('.create_request').on 'click', (event) ->
		event.preventDefault()
		$.post url

	$.get(window.location.origin + '/requests.json', (data) ->
		$.each(data.requests, (index, request) ->
			request.position = index + 1
			newRequest = Mustache.render($('#request').html(),request)
			$(newRequest).appendTo('.scroll ul')
		)
	)

	dispatcher = new WebSocketRails(window.location.host + '/websocket');
		
	channel = dispatcher.subscribe 'requests'
	channel.bind 'new', (request) ->
		if($('.scroll ul').length)
			$.get(window.location.origin + '/requests.json', (data) ->
				newData = data.requests[data.requests.length-1]
				newData.position = data.requests.length
				newRequest = Mustache.render($('#request').html(),newData)
				$(newRequest).appendTo('.scroll ul')
		)

#request.description