extends Spatial

export(Resource) var enemy1

export var score = 0

export(NodePath) var status_hud_path
var status_hud = null

onready var player = get_node("Turret001")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var timer = Timer.new()
	timer.set_wait_time(10.0)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "spawn_enemy")
	add_child(timer)
	timer.start()
	
	status_hud = get_node(status_hud_path)
	if status_hud:
		status_hud.hvalue = player.health
		status_hud.svalue = score
	
func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func _process(delta):
	pass
	
func spawn_enemy():
	var enemy1_instance = enemy1.instance()
	var pos = random_circle(Vector3(0, 3, 0), 50.0)
	enemy1_instance.global_transform.origin = pos
	enemy1_instance.target_group = "ally"
	enemy1_instance.add_to_group("enemy")
	get_tree().get_root().add_child(enemy1_instance)
	enemy1_instance.connect("ai_dead", self, "_on_Enemy_ai_dead")
	
func random_circle(center, radius):
	var angle = randf() * 360
	var sin_angle = sin(deg2rad(angle))
	var cos_angle = cos(deg2rad(angle))
	
	var posx = center.x + radius * sin_angle
	var posz = center.z + radius * cos_angle
	var posy = center.y
	
	return Vector3(posx, posy, posz)

func _on_Enemy_ai_dead():
	score += 50
	if status_hud:
		status_hud.set_hud_score_value(score)
	
func _on_Turret001_player_dead():
	get_tree().change_scene("res://Scenes/GameOver.tscn")

func _on_Turret001_player_hurt(arg):
	if status_hud:
		status_hud.set_hud_value(arg)
