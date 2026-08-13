extends Control

const URL: String = "https://meowfacts.herokuapp.com/"

@onready var button: Button = $Button
@onready var http_request: HTTPRequest = $Button/HTTPRequest
@onready var label: Label = $Label


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	http_request.request_completed.connect(_on_http_request_request_completed)


func _on_button_pressed() -> void:
	http_request.request(URL)


func _on_http_request_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if !result and response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		label.text = data.data[0]
	else:
		label.text = "Request failed: result %d, code %d" % [result, response_code]
