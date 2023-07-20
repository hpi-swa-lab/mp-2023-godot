extends HTTPRequest
class_name Fetch

@export var experience_generator: ExperienceGenerator

@export_multiline var test_json: String

func _ready():
	var json = JSON.parse_string(test_json)
	print(json)
	experience_generator.generate_experience(json)


func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	experience_generator.generate_experience(json.data)


func submit_answer(answer):
	print(answer)


func _on_submit_button_button_pressed():
	submit_answer("hi")
