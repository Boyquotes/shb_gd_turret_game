extends Control

export(Resource) var next_scene

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Restart_pressed():
	get_tree().change_scene(next_scene.resource_path)
