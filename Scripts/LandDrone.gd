# script ini untuk mengendalikan musuh, yakni land drone.

# extend dari KinematicBody.
extends KinematicBody

# tergantung nilai yang diisi di inspector.
# secara default ally.
# ally, dalam project ini adalah player, dan jika ada, team nya.
# land drone itu sendiri ada di group enemy dalam project ini.
export var target_group = "ally"

# gravitasi.
export var gravity = Vector3(0, -400, 0)

# kecepatan berjalan.
export var speed = 300

# nilai health.
export var health = 10

# usia sejak land drone menabrak turret.
# catatan: land drone memberi damage pada turret dengan menabrak turret.
export var lifetime: float = 0.8

# referensi ke sound efffect.
export(Resource) var exp_sound

# referensi ke node animasi.
onready var animation_player = get_node("AnimationPlayer")

var vel = Vector3.ZERO
var player = null
var dirty = false

# pelajari signal terlebih dahulu.
signal ai_dead

func _ready():
	# memulai animasi.
	animation_player.get_animation("Idle").set_loop(true)
	animation_player.get_animation("Walk").set_loop(true)
	animation_player.play("Idle")
	dirty = false
	
func _physics_process(delta):
	# incar player
	var nds = get_tree().get_nodes_in_group(target_group)
	#print(nds)
	if nds.size() > 0:
		randomize()
		var rndsidx = rand_range(0, nds.size() - 1);
		#print(rndsidx)
		player = nds[rndsidx]
		if player:
			player = player.get_node("Base/Body")
	
	if player and is_instance_valid(player):
		# berjalan mengarah turret.
		look_at(player.global_transform.origin, Vector3.UP)
		vel  = (player.global_transform.origin - global_transform.origin).normalized() * speed * delta
	
	# animasi sesuai velocity
	if vel != Vector3.ZERO:
		animation_player.play("Walk")
	else:
		animation_player.play("Idle")
		
	if not is_on_floor():
		# jika tidak menyentuh lantai, maka jatuhlah.
		vel +=  gravity * delta
	
	# gerakkan land drone.
	vel = move_and_slide(vel, Vector3.UP)

	# uji collision dengan turret.
	# dirty menandakan hanya sekali pengujian.
	var collision = get_slide_collision(0)
	if collision and not dirty:
		if collision.collider.get_groups().has(target_group):
			# jika yang ditabrak adalah player turret.
			
			print (collision.collider.name)
			
			# turret menerima damage.
			collision.collider.damage()
			dirty = true
			
			# mainkan sound effect.
			var asp = AudioStreamPlayer.new()
			add_child(asp)
			asp.stream = load(exp_sound.resource_path)
			asp.play()
			
			# tunggu sebentar, lalu hapus land drone.
			yield(get_tree().create_timer(lifetime),"timeout")
			queue_free()

# untuk menerima damage.	
func damage():
	health = health - 1
	if health <= 0:
		# jika land drone mati.
		
		print("enemy is dead")
		
		# mainkan sound effect.
		var asp = AudioStreamPlayer.new()
		add_child(asp)
		asp.stream = load(exp_sound.resource_path)
		asp.play()
		
		# tunggu sebentar, lalu hapus land drone.
		yield(get_tree().create_timer(0.5),"timeout")
		queue_free()
		
		emit_signal("ai_dead")
