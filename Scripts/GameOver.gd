# script ini mengatur scene GameOver.tscn.

# extend dari Control.
extends Control

# scene selanjutnya.
export(Resource) var next_scene

func _ready():
	# tampilkan mouse cursor.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Restart_pressed():
	# ganti ke scene selanjutnya.
	get_tree().change_scene(next_scene.resource_path)
