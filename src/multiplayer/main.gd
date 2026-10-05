extends Control

@onready var ui: VBoxContainer = $UI
@onready var server_button: Button = $VBoxContainer/ServerButton
@onready var client_button: Button = $VBoxContainer/ClientButton


func _ready() -> void:
	server_button.pressed.connect(_on_server_button_pressed)
	client_button.pressed.connect(_on_client_button_pressed)


func _on_server_button_pressed() -> void:
	NetworkHandler.start_server()
	ui.hide()


func _on_client_button_pressed() -> void:
	NetworkHandler.start_client()
	ui.hide()
