extends CharacterBody2D


const SPEED = 170.0
const JUMP_FORCE = -400.0
var is_jumping := false
@onready var Animator := $Animation
@onready var RemoteTransform := $Remote
@onready var RayLeft := $RayLeft
@onready var RayRight := $RayRight
@export var playerLife := 10
var KNockbackVEctor := Vector2.ZERO
var direction := 1.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		Animator.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if KNockbackVEctor != Vector2.ZERO:
		velocity = KNockbackVEctor
		
	_set_state()
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
		
	
	

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if playerLife > 0:
			if $RayRight.is_colliding():
				take_damage(Vector2(-200, -200))
			elif $RayLeft.is_colliding():
				take_damage(Vector2(200, -200))
		else:
			queue_free()
		
func follow_camera(camera):
	var camera_path = camera.get_path()
	RemoteTransform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	playerLife -= 1
	
	if knockback_force != Vector2.ZERO:
		KNockbackVEctor = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, "KNockbackVEctor", Vector2.ZERO, duration)
		Animator.modulate = Color(1,0,0,1)
		knockback_tween.tween_property(Animator, "modulate", Color(1,1,1,1), duration)

func _set_state():
	var state = "idle"
	
	if KNockbackVEctor != Vector2.ZERO:
		state = "hurt"
	elif !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if Animator.name != state:
		Animator.play(state)


func _on_head_collider_body_entered(body: Node2D) -> void:
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints <= 0:
			body.break_sprite()
		else:
			body.Animator.play("hit")
		body.spawn_coin()
