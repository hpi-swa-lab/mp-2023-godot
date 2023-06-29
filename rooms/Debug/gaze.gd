extends RayCast3D
class_name Gaze


signal target_selected(target: GazeTarget)


@export var gaze_activate_threshold = 0.3


var active_target: GazeTarget
var curr_target_activation: float
var active_target_deactivation: float
var prev_target: GazeTarget


func _physics_process(delta):
	if is_colliding():
		var collider = get_collider()
		if collider is GazeTarget:
			var curr_target = collider as GazeTarget
			
			# ignore if still looking at same target
			if curr_target == active_target:
				# quick target switching from active to another needs to get reset here
				if curr_target != prev_target and prev_target != null:
					prev_target.on_focus_inactive()
				return

			# still looking at same target
			if curr_target == prev_target:
				curr_target_activation += delta
				if curr_target_activation > gaze_activate_threshold:
					# new target
					curr_target.on_focus_active()
					if active_target != null:
						# disable the previous active target
						active_target.on_focus_inactive()
					active_target = curr_target
					target_selected.emit(curr_target)
				else:
					# highlight as long as activation is not building up
					curr_target.highlight(curr_target_activation / gaze_activate_threshold)
			elif curr_target != prev_target:
				# target switching
				curr_target_activation = 0.0
				if prev_target != null and prev_target != active_target:
					prev_target.on_focus_inactive()

			prev_target = curr_target
	# lower highlight effect for previously targeted
	elif prev_target != null and prev_target != active_target and curr_target_activation > 0.0:
		curr_target_activation = max(curr_target_activation - delta, 0.0)
		prev_target.highlight(curr_target_activation / gaze_activate_threshold)
		if curr_target_activation <= 0.0:
			prev_target.on_focus_inactive()
