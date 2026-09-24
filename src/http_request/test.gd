extends Control

const HOST: String = "https://api-afli.onrender.com"
const CONTENT_TYPE: String = "Content-Type:application/x-www-form-urlencoded"

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var label: Label = $Label
@onready var get_all_button: Button = $Buttons/GetAllButton
@onready var get_one_button: Button = $Buttons/GetOneButton
@onready var post_button: Button = $Buttons/PostButton
@onready var put_button: Button = $Buttons/PutButton
@onready var delete_button: Button = $Buttons/DeleteButton


## It directly modifies the database? It's not stateless... this could be bad
func _ready() -> void:
	## If you want to make it cleaner, consider using an Array
	## to store methods and params, and connect signals (ex. below)
	#for index: int in range(buttons.get_child_count()):
	#buttons.get_child(index).pressed.connect(_on_button_pressed.bind(requests[index]))
	get_all_button.pressed.connect(_on_get_button_pressed)
	get_one_button.pressed.connect(_on_get_button_pressed.bind(1))
	post_button.pressed.connect(_on_post_button_pressed.bind(5))
	put_button.pressed.connect(_on_put_button_pressed.bind(3))
	delete_button.pressed.connect(_on_delete_button_pressed.bind(1))

	http_request.request_completed.connect(_on_http_request_completed)


func _on_get_button_pressed(id: int = -1) -> void:
	var url: String = "%s/api/posts" % [HOST]
	if id > 0:
		url += "/%d" % id
	var method: HTTPClient.Method = HTTPClient.METHOD_GET
	var headers: PackedStringArray = [CONTENT_TYPE]
	http_request.request(url, headers, method)


func _on_post_button_pressed(id: int) -> void:
	var url: String = "%s/api/posts" % [HOST]
	var method: HTTPClient.Method = HTTPClient.METHOD_POST
	var headers: PackedStringArray = [CONTENT_TYPE]
	var params: PackedStringArray = [
		"id=%d" % id,
		"title=Post",
	]
	http_request.request(url, headers, method, "&".join(params))


func _on_put_button_pressed(id: int) -> void:
	var url: String = "%s/api/posts/%d" % [HOST, id]
	var method: HTTPClient.Method = HTTPClient.METHOD_PUT
	var headers: PackedStringArray = [CONTENT_TYPE]
	var params: PackedStringArray = [
		"title=Put",
	]
	http_request.request(url, headers, method, "&".join(params))


func _on_delete_button_pressed(id: int) -> void:
	var url: String = "%s/api/posts/%d" % [HOST, id]
	var method: HTTPClient.Method = HTTPClient.METHOD_DELETE
	var headers: PackedStringArray = [CONTENT_TYPE]
	http_request.request(url, headers, method)


func _on_http_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if !result and (response_code == 200 or response_code == 201):
		var data: Variant = body.get_string_from_utf8()
		label.text = data
	else:
		label.text = "Request failed: code %d\n%s" % [response_code, body.get_string_from_utf8()]


## DEPRECATED
func _on_button_pressed(method: HTTPClient.Method) -> void:
	http_request.request(HOST, PackedStringArray(["Content-Type:application/x-www-form-urlencoded"]), method)
