# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	dispatcher = new WebSocketRails(window.location.host + '/websocket');
	channel_approval = dispatcher.subscribe 'student_approval'
	channel_approval.bind 'student_approval', (student) ->
		$.get(window.location.origin + '/current_user', (current_student) ->
			if current_student.id == student.id
				if student.approved == true
					console.log("Approved")
					window.location.pathname = "/students/require_approval"
				else
					console.log("Unapproved")
					window.location.pathname = "/students/require_approval"
		)

	channel_batch_approval = dispatcher.subscribe 'student_batch_approval'
	channel_batch_approval.bind 'student_batch_approval', (students) ->
		$.each(students, (index, student) ->
			$.get(window.location.origin + '/current_user', (current_student) ->
				if current_student.id == student.id
					if student.approved == true
						console.log("Approved")
						window.location.pathname = "/students/require_approval"
					else
						console.log("Unapproved")
						window.location.pathname = "/students/require_approval"
			)
		)
			