json.requests @requests do |request|
	json.request_id request.id
	json.student_name request.student.name
	json.position 1
    json.time request.created_at.strftime( '%l:%M%p' )
    json.category request.category_name
    json.gravatar_url request.student.gravatar_url
    json.description request.description
    if request.student == current_student
    	json.my_request true
    	json.edit_url edit_request_url(request)
    	json.delete_url request_url(request)
    end
end
