extends CharacterBody2D

@onready var wall_detector := $wall_detector as RayCast2D

const SPEED = 1400.0
const JUMP_VELOCITY = -400.0
var direction:=-1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * SPEED * delta

	if wall_detector.is_colliding():
		direction*=-1
		self.scale.x*=-1;
	move_and_slide()
