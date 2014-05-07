# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('.create_request').on 'click', (event) ->
		event.preventDefault()
		$.post url
	getStudentsRequests = (url,list_target) ->
		$.get(url, (data) ->
			$.each(data.requests, (index, request) ->
				request.position = index + 1
				newRequest = Mustache.render($('#request').html(),request)
				$(newRequest).appendTo(list_target)
				$('.waitingList img[data-src]').each ->
					$(this).attr('src', $(this).attr('data-src'))
					$(this).attr('data-src', '')
			)
			prettyPrint();
		)

	subscribeToWebSockets = (url,list_target) ->
		dispatcher = new WebSocketRails(window.location.host + '/websocket');
		channel_created = dispatcher.subscribe 'request_created'
		channel_created.bind 'new', (request) ->
			if($(list_target).length)
				$.get(url, (data) ->
					if data.requests.length > $(list_target + ' li').length
						newData = data.requests[data.requests.length-1]
						newData.position = data.requests.length
						newRequest = Mustache.render($('#request').html(),newData)
						$(newRequest).appendTo(list_target)
						prettyPrint();
				)
		channel_deleted = dispatcher.subscribe 'request_deleted'
		channel_deleted.bind 'destroy', (request_id) ->
			if($(list_target).length)
				$("##{request_id}").remove()
				$(list_target + ' li').each (index, request) ->
					$(request).find('.position').html(index+1)

		channel_solved = dispatcher.subscribe 'request_solved'
		channel_solved.bind 'solved', (request_id) ->
			if($(list_target).length)
				$("##{request_id}").remove()
				$(list_target + ' li').each (index, request) ->
					$(request).find('.position').html(index+1)

		channel_edited = dispatcher.subscribe 'request_edited'
		channel_edited.bind 'edit', (request_id) ->
			if($(list_target).length)
				$.get(url, (data) ->
					$.each(data.requests, (index, request) ->
						if(request.request_id == request_id)
							editedRequest = Mustache.render($('#request').html(),request)
							$("##{request_id}").replaceWith(editedRequest)
							$(list_target + ' li').each (index, request) ->
								$(request).find('.position').html(index+1)
					)
					prettyPrint();
				)


	if window.location.pathname == "/requests/display"
		$.get(window.location.origin + '/cohorts/current_cohorts.json', (data) ->
			list_target_cohort1 = ".scroll.#{data.cohorts[0].cohort_name} ul"
			list_target_cohort2 = ".scroll.#{data.cohorts[1].cohort_name} ul"
			url_cohort1 = window.location.origin + '/requests.json?cohort=' + data.cohorts[0].cohort_id
			url_cohort2 = window.location.origin + '/requests.json?cohort=' + data.cohorts[1].cohort_id
			getStudentsRequests(url_cohort1, list_target_cohort1)
			getStudentsRequests(url_cohort2, list_target_cohort2)
			subscribeToWebSockets(url_cohort1,list_target_cohort1)
			subscribeToWebSockets(url_cohort2,list_target_cohort2)
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

		getStudentsRequests(getRequest, ".scroll ul")
		subscribeToWebSockets(getRequest, '.scroll ul')

		