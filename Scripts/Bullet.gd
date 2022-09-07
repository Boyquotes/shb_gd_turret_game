# script ini mengendalikan peluru dari turret

# extend dari RigidBody.
extends RigidBody

# group menentukan siapa yang menerima damage.
export var target_group = "enemy"

# kecepatan peluru.
export var speed :float = 100.0

# usia peluru.
export var lifetime: float = 0.8

# referensi ke suara peluncuran.
export(Resource) var projectile_sound

func _ready():
	# mainkan suara peluncuran peluru.
	var asp = AudioStreamPlayer.new()
	add_child(asp)
	asp.stream = load(projectile_sound.resource_path)
	asp.play()
	
	# gerakkan peluru.
	linear_velocity = -global_transform.basis.z * speed
	
	# jika mencapai usia, hapus.
	yield(get_tree().create_timer(lifetime),"timeout")
	queue_free()

func _on_Bullet_body_entered(body):
	if body.get_groups().has(target_group):
		# jika penerima damage
		
		# lakukan damage
		body.damage()
	
