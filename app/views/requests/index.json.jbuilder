# frozen_string_literal: true

json.requests @requests do |request|
  json.request_id request.id
  json.student_name request.student.name
  json.position 1
  json.time request.created_at.strftime('%l:%M%p')
  json.category request.category.name
  json.gravatar_url request.student.gravatar_url
  json.description request.description
  if request.student == current_student || current_teacher
    json.my_request true
    json.edit_url edit_request_url(request)
    json.delete_url request_url(request)
  end
  if current_teacher
    json.current_teacher true
    json.solved_url request_path(request, request: { solved: true })
  end
end
