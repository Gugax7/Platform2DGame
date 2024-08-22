extends CharacterBody2D
@onready var animation = $AnimatedSprite2D
var is_hurting = false

const SPEED = 170.0
const JUMP_VELOCITY = -385.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	handle_animation()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	if velocity.x < 0:
		animation.flip_h = true
