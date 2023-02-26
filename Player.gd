extends KinematicBody2D

export(int) var jump_force = -130
export(int) var jump_release_force = -70
export(int) var max_speed = 50
export(int) var acceleration = 10
export(int) var friction = 10
export(int) var gravity = 4
export(int) var additonal_fall_gravity = 4
onready var aniimated_sprite = $AnimatedSprite
var velocity = Vector2.ZERO

func _physics_process(delta):
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:
		apply_friction()
		aniimated_sprite.animation = "idle"
	else:
		apply_acceleration(input.x)
		aniimated_sprite.animation = "run"
		if input.x > 0:
			aniimated_sprite.flip_h = true
		elif input.x < 0:
			aniimated_sprite.flip_h = false
	
	if is_on_floor():
	
		if Input.is_action_pressed("ui_up"):
			velocity.y = jump_force
	else:
		aniimated_sprite.animation = "jump"
		if Input.is_action_just_released("ui_up") and velocity.y < jump_release_force:
			velocity.y = jump_release_force
		if velocity.y > 0:
			
			velocity.y += additonal_fall_gravity
		
	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity,Vector2.UP)
	var just_landed = is_on_floor() and  was_in_air
	if just_landed:
		aniimated_sprite.animation = "run"
		aniimated_sprite.frame = 1
func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, 300)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, friction)

func apply_acceleration(ammount):
	velocity.x = move_toward(velocity.x, max_speed * ammount, acceleration)
