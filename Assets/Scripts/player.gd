extends CharacterBody2D
@onready var animation = $AnimatedSprite2D
var is_hurting = false
@onready var invisible_sword = $InvisibleSword


const SPEED = 170.0
const JUMP_VELOCITY = -385.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Global.player_body = self
func _physics_process(delta):
	handle_animation()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("attack"):
		toggle_attack_area()
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func handle_animation():
	if !is_hurting:
		if velocity.length() > 0 and is_on_floor():
			animation.play("Running")
		elif velocity.x == 0 and is_on_floor():
			animation.play("Idle")
		else:
			animation.play("Jump")
	
	if velocity.x > 0:
		animation.flip_h = false
		invisible_sword.scale.x = 1
	elif velocity.x < 0:
		animation.flip_h = true
		invisible_sword.scale.x = -1
func toggle_attack_area():
	var damage_zone = invisible_sword.get_node("CollisionShape2D")
	damage_zone.disabled = false
	await get_tree().create_timer(.2).timeout
	damage_zone.disabled = true
func hit():
	print("aiaiaia")
	

	


func _on_invisible_sword_area_entered(area):
	print(area.name)
	if area.name == "Hitbox":
		area.get_parent().hurt()
		area.get_parent().scale.x = self.scale.x
