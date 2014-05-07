# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('.create_request').on 'click', (event) ->
		event.preventDefault()
		$.post url

	if window.location.pathname == "/requests/display"
		$.get(window.location.origin + '/cohorts/current_cohorts.json', (data) ->

			$.get(window.location.origin + '/requests.json?cohort=' + data.cohorts[0].cohort_id, (cohort1_data) ->
				$.each(cohort1_data.requests, (index, request) ->
					request.position = index + 1
					newRequest = Mustache.render($('#request').html(),request)
					console.log(".#{data.cohorts[0].cohort_name} .scroll ul")
					$(newRequest).appendTo(".scroll.#{data.cohorts[0].cohort_name} ul")
					$('.waitingList img[data-src]').each ->
						$(this).attr('src', $(this).attr('data-src'))
						$(this).attr('data-src', '')
				)
				prettyPrint();
			)

			$.get(window.location.origin + '/requests.json?cohort=' + data.cohorts[1].cohort_id, (cohort2_data) ->
				$.each(cohort2_data.requests, (index, request) ->
					request.position = index + 1
					newRequest = Mustache.render($('#request').html(),request)
					console.log(".#{data.cohorts[1].cohort_name} .scroll ul")
					$(newRequest).appendTo(".scroll.#{data.cohorts[1].cohort_name} ul")
					$('.waitingList img[data-src]').each ->
						$(this).attr('src', $(this).attr('data-src'))
						$(this).attr('data-src', '')
				)
				prettyPrint();
			)
		)
	else

		getParams = ->
			query = window.location.search.substring(1)
			raw_vars = query.split("&")
			params = {}
			for v in raw_vars
				[key, val] = v.split("=")
				params[key] = decodeURIComponent(val)
			params

		if getParams().cohort
			getRequest = window.location.origin + '/requests.json?' + 'cohort=' + getParams().cohort
		else
			getRequest = window.location.origin + '/requests.json'

		$.get(getRequest, (data) ->
			$.each(data.requests, (index, request) ->
				request.position = index + 1
				newRequest = Mustache.render($('#request').html(),request)
				$(newRequest).appendTo('.scroll ul')
				$('.waitingList img[data-src]').each ->
					$(this).attr('src', $(this).attr('data-src'))
					$(this).attr('data-src', '')
			)
			prettyPrint();
		)

		dispatcher = new WebSocketRails(window.location.host + '/websocket');
			
		channel_created = dispatcher.subscribe 'request_created'
		channel_created.bind 'new', (request) ->
			if($('.scroll ul').length)
				$.get(getRequest, (data) ->
					newData = data.requests[data.requests.length-1]
					newData.position = data.requests.length
					newRequest = Mustache.render($('#request').html(),newData)
					$(newRequest).appendTo('.scroll ul')
					prettyPrint();
				)

		channel_deleted = dispatcher.subscribe 'request_deleted'
		channel_deleted.bind 'destroy', (request_id) ->
			if($('.scroll ul').length)
				$("##{request_id}").remove()
				$('.scroll ul li').each (index, request) ->
					$(request).find('.position').html(index+1)

		channel_solved = dispatcher.subscribe 'request_solved'
		channel_solved.bind 'solved', (request_id) ->
			if($('.scroll ul').length)
				$("##{request_id}").remove()
				$('.scroll ul li').each (index, request) ->
					$(request).find('.position').html(index+1)

		channel_edited = dispatcher.subscribe 'request_edited'
		channel_edited.bind 'edit', (request_id) ->
			if($('.scroll ul').length)
				$.get(getRequest, (data) ->
					$.each(data.requests, (index, request) ->
						if(request.request_id == request_id)
							editedRequest = Mustache.render($('#request').html(),request)
							$("##{request_id}").replaceWith(editedRequest)
							$('.scroll ul li').each (index, request) ->
								$(request).find('.position').html(index+1)
					)
					prettyPrint();
				)