extends HTTPRequest
class_name Fetch

@export var experience_manager: ExperienceManager
@export var server_url = "127.0.0.1"
@export var port = "5000"
@export var status_get_route = "/status"
@export var response_post_route = "/response"
@export var time_to_poll = 1.0

@export_multiline var test_json: String

@onready var request_url = "http://" + server_url + ":" + port

var start_time: int
var state_id: int
var waiting_for_response = false
var current_polling_time = 0.0

#func _ready():
#	request_status()
#	var json = JSON.parse_string(test_json)
#	experience_manager.reset_experience()
#	experience_manager.generate_experience(json)
#	state_id = 1


func _process(delta):
	current_polling_time += delta
	if waiting_for_response or current_polling_time < time_to_poll:
		return
	
	current_polling_time = 0.0
	request_status()


func _on_request_completed(result, response_code, headers, body):
	waiting_for_response = false
	
	if response_code != 200 or body == null:
		printerr("Something went wrong with the request. Response code: " + str(response_code) + " and body is: " + str(body))
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	if json:
#		print(json)
		if state_id != null and state_id != json["stateId"]:
			print(json)
			experience_manager.reset_experience()
			experience_manager.generate_experience(json)
		else:
			print(Time.get_datetime_string_from_system() + " same state id. skipping state update")
		state_id = json["stateId"]


func request_status():
	var error = request(request_url + status_get_route)
	waiting_for_response = true
	
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _on_submit_button_button_down():
	var end_time = Time.get_ticks_msec()
	var duration = end_time - start_time
	
	var json = JSON.stringify({"view" : "VR", "stateId" : state_id, "duration" : duration})
	var headers = ["Content-Type: application/json"]
	var error = request(request_url + response_post_route, headers, HTTPClient.METHOD_POST, json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _on_experience_manager_experience_started():
	start_time = Time.get_ticks_msec()
	print("experience started")


func _on_experience_manager_experience_finished():
	var end_time = Time.get_ticks_msec()
	var duration = end_time - start_time
	
	var json = JSON.stringify({"view" : "VR", "stateId" : state_id, "duration" : duration})
	var headers = ["Content-Type: application/json"]
	var error = request(request_url + response_post_route, headers, HTTPClient.METHOD_POST, json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
