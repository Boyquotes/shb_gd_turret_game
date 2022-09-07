# script ini mengendalikan turret.

# extend dari KinematicBody.
extends KinematicBody

# begin: variabel ini bisa di-edit di inspector.
export var rotation_speed_horizontal : float = 10.0
export var rotation_speed_vertical : float = 10.0
export var input_mouse_horizontal : float = 0.0
export var input_mouse_vertical : float = 0.0
export var health : float = 50.0
# end: variabel ini bisa di-edit di inspector.

# begin: referensi ke node.
onready var turret_horizontal = get_node("Base/Body")
onready var turret_vertical = get_node("Base/Body/Muzzle")
onready var cam_horizontal = get_node("CameraRoot/Horizontal")
onready var cam_vertical = get_node("CameraRoot/Horizontal/Vertical")
onready var cam = get_node("CameraRoot/Horizontal/Vertical/ClippedCamera")
onready var spawn = get_node("Base/Body/Muzzle/Spawn")
# end: referensi ke node.

# begin: variabel ini bisa di-edit di inspector.
export(Resource) var bullet
export(Resource) var exp_sound
# end: variabel ini bisa di-edit di inspector.

# pelajari signal terlebih dahulu.
signal player_hurt
signal player_dead

func _ready():
	#cam.add_exception(get_parent())
	pass
	
func _process(delta):
	# untuk memutar kamera.
	cam_horizontal.rotation_degrees.y -= input_mouse_horizontal * rotation_speed_horizontal * delta
	cam_vertical.rotation_degrees.x += input_mouse_vertical * rotation_speed_vertical * delta
	
	# untuk memutar turret.
	turret_horizontal.rotation_degrees.y = cam_horizontal.rotation_degrees.y
	turret_vertical.rotation_degrees.x = cam_vertical.rotation_degrees.x
	
	input_mouse_horizontal = 0.0
	input_mouse_vertical = 0.0
	
func _input(event):
	if event.is_action_pressed("shoot"):
		# tembakkan bullet.
		var bullet_instance = bullet.instance()
		bullet_instance.global_transform = spawn.global_transform
		bullet_instance.target_group = "enemy"
		get_tree().get_root().add_child(bullet_instance)
		
	if event is InputEventMouseMotion:
		input_mouse_horizontal = event.relative.x
		input_mouse_vertical = event.relative.y

# untuk menerima damage.
func damage():
	health = health - 1
	emit_signal("player_hurt", health)
		
	if health <= 0:
		# jika turret player mati.
		
		# mainkan sound effect.
		var asp = AudioStreamPlayer.new()
		add_child(asp)
		asp.stream = load(exp_sound.resource_path)
		asp.play()
		
		# tunggu sebentar, lalu hapus turret.
		yield(get_tree().create_timer(0.5),"timeout")
		queue_free()
		emit_signal("player_dead")
