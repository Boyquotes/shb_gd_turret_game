# script ini mengatur scene StartMenu.tscn.

# extend dari Control.
extends Control

# scene selanjutnya.
export(Resource) var next_scene

func _ready():
	# tampilkan mouse cursor.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Start_pressed():
	# ganti ke scene selanjutnya.
	get_tree().change_scene(next_scene.resource_path)

func _on_Quit_pressed():
	# keluar game.
	get_tree().quit()
