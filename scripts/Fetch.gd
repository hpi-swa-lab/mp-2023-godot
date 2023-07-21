extends HTTPRequest
class_name Fetch

@export var experience_generator: ExperienceGenerator
@export var server_url = "http://127.0.0.1:5000"
@export var sample_get_route = "/status"

@export_multiline var test_json: String

func _ready():
	var error = request(server_url + sample_get_route)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(response_code)
	print(json)
	if json:
		experience_generator.generate_experience(json)
	else:
		printerr("Something went wrong with the request...")


func submit_answer(answer):
	print(answer)


func _on_submit_button_button_pressed():
	submit_answer("hi")
