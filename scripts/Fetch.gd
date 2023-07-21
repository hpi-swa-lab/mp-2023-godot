extends HTTPRequest
class_name Fetch

@export var experience_manager: ExperienceManager
@export var server_url = "http://127.0.0.1:5000"
@export var status_get_route = "/status"
@export var response_post_route = "/response"

@export_multiline var test_json: String

var start_time: int
var state_id: int

func _ready():
	request_status()


func _on_request_completed(result, response_code, headers, body):
	if response_code != 200 or body == null:
		printerr("Something went wrong with the request. Response code: " + str(response_code) + " and body is: " + str(body))
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	if json:
		print(json)
		experience_manager.generate_experience(json)
		state_id = json["stateId"]


func request_status():
	var error = request(server_url + status_get_route)
	if error != OK:
		push_error("An error occurred in the HTTP request.")



func _on_submit_button_button_down():
	var end_time = Time.get_ticks_msec()
	var duration = end_time - start_time
	
	var json = JSON.stringify({"platform" : "VR", "stateId" : state_id, "duration" : duration})
	var headers = ["Content-Type: application/json"]
	var error = request(server_url + response_post_route, headers, HTTPClient.METHOD_POST, json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _on_experience_manager_experience_started():
	start_time = Time.get_ticks_msec()
	print("experience started")
