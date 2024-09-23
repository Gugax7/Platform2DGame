extends CharacterBody2D

@onready var wall_detector := $wall_detector as RayCast2D
@onready var anim = $anim
@onready var texture = $texture
var knockback_vector := Vector2.ZERO
var blood = preload("res://Assets/PreFabs/hurt_particle.tscn")

const SPEED = 1400.0
const JUMP_VELOCITY = -400.0
var direction:=-1
var player : CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	player = Global.player_body
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * SPEED * delta

	if wall_detector.is_colliding():
		direction*=-1
		self.scale.x*=-1;
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	move_and_slide()

func hurt():
	var particle_to_right = true
	var knockback_tween := get_tree().create_tween()
	if player.global_position.x > global_position.x:
		particle_to_right = false
	#player is on right
	if player.global_position.x > global_position.x and velocity.x < 0:
		texture.flip_h = true
		
		
	#player is on left
	elif player.global_position.x < global_position.x and velocity.x > 0:
		texture.flip_h = true
		
	
	if particle_to_right:
		knockback_vector = Vector2(200,-200)
		knockback_tween.tween_property(self,"knockback_vector",Vector2.ZERO,0.25)
	else:
		knockback_vector = Vector2(-200,-200)
		knockback_tween.tween_property(self,"knockback_vector",Vector2.ZERO,0.25)
	
	await get_tree().create_timer(0.1).timeout
	var blood_instance = blood.instantiate()
	blood_instance.global_position = global_position
	blood_instance.emitting = true
	if not particle_to_right:
		blood_instance.rotation_degrees = 180
	get_parent().add_child(blood_instance)
	anim.play("hurt")


func _on_anim_animation_finished(anim_name):
	anim.play("walking")
	texture.flip_h = false

