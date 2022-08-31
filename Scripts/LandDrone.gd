extends KinematicBody

export var target_group = "ally"
export var gravity = Vector3(0, -400, 0)
export var speed = 300
export var health = 10
export var lifetime: float = 0.8
export(Resource) var exp_sound

onready var animation_player = get_node("AnimationPlayer")

var vel = Vector3.ZERO
var player = null
var dirty = false

signal ai_dead

func _ready():
	animation_player.get_animation("Idle").set_loop(true)
	animation_player.get_animation("Walk").set_loop(true)
	animation_player.play("Idle")
	dirty = false
	
func _physics_process(delta):
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
		look_at(player.global_transform.origin, Vector3.UP)
		vel  = (player.global_transform.origin - global_transform.origin).normalized() * speed * delta
	
	if vel != Vector3.ZERO:
		animation_player.play("Walk")
	else:
		animation_player.play("Idle")
		
	if not is_on_floor():
		vel +=  gravity * delta
	
	vel = move_and_slide(vel, Vector3.UP)

	var collision = get_slide_collision(0)
	if collision and not dirty:
		if collision.collider.get_groups().has(target_group):
			collision.collider.damage()
			dirty = true
			
			var asp = AudioStreamPlayer.new()
			add_child(asp)
			asp.stream = load(exp_sound.resource_path)
			asp.play()
			
			yield(get_tree().create_timer(lifetime),"timeout")
			queue_free()
	
func damage():
	health = health - 1
	if health <= 0:
		print("enemy is dead")
		
		var asp = AudioStreamPlayer.new()
		add_child(asp)
		asp.stream = load(exp_sound.resource_path)
		asp.play()
		
		yield(get_tree().create_timer(0.5),"timeout")
		queue_free()
		
		emit_signal("ai_dead")
