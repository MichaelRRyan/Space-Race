extends RigidBody2D

export var movement_force : float = 10000.0
export var rotation_force : float = 20000.0
export var adjust_force : float = 800.0
export var adjust_rotation_force : float = 1000.0


onready var _left_particle : Particles2D = get_node("FlameParticlesLeft")
onready var _right_particle : Particles2D = get_node("FlameParticlesRight")


func _process(delta):
	if Input.is_action_pressed("main_action"):
		var mouse_pos = get_global_mouse_position()
		var dist = mouse_pos - global_position
		var dir = dist.normalized()
		
		var look_dir = Vector2(cos(rotation), sin(rotation))
		var rot = look_dir.angle_to(dir)
		
		apply_torque_impulse(rot * rotation_force * delta)
		apply_central_impulse(look_dir * movement_force * delta)

		_left_particle.emitting = true
		_right_particle.emitting = true
	else:
		_left_particle.emitting = false
		_right_particle.emitting = false
	
	if Input.is_action_pressed("second_action"):
		var mouse_pos = get_global_mouse_position()
		var dist = mouse_pos - global_position
		var dir = dist.normalized()
		
		var look_dir = Vector2(cos(rotation), sin(rotation))
		var rot = look_dir.angle_to(dir)
		
		var perp = Vector2(-look_dir.y, look_dir.x) * sign(rot)
		
		var rot2 = perp.angle_to(dir)
		apply_torque_impulse(rot2 * adjust_rotation_force * delta)
		
		if rot > 0:
			apply_central_impulse(perp * adjust_force * delta)
			$FlameParticlesLeftSide.emitting = true
			$FlameParticlesRightSide.emitting = false
		
		else:
			apply_central_impulse(perp * adjust_force * delta)
			$FlameParticlesLeftSide.emitting = false
			$FlameParticlesRightSide.emitting = true
		
	else:
		$FlameParticlesLeftSide.emitting = false
		$FlameParticlesRightSide.emitting = false
		
		

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
