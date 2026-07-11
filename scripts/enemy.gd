extends CharacterBody2D

const SPEED = 30.0
const JUMP_VELOCITY = -400.0
var direction := -1

@onready var WallDetector := $WallDetector as RayCast2D
@onready var texture := $texture as Sprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if WallDetector.is_colliding():
		direction *= -1
		$texture.flip_h = not $texture.flip_h
		WallDetector.target_position.x *= -1

	velocity.x = direction * SPEED

	move_and_slide()


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		queue_free()
