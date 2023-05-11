extends Path3D


#var mail : Node3D
var left_controller : XRController3D
var progress = 0.0
var mails : Array
var mail_path : PathFollow3D
var left_hand_picked_up_mail_index = -1
var right_hand_picked_up_mail_index = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	mails = [
		get_node("../Mail"),
		get_node("../Mail2"),
		get_node("../Mail3"),
	]
	mail_path = $PathFollow3D
	left_controller = get_node("../XROrigin3D/LeftHand")
	
	for i in mails.size():
			if i == right_hand_picked_up_mail_index or i == left_hand_picked_up_mail_index: continue
			
			mails[i].position = calculate_mail_position(i, progress)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if left_controller == null: return
	
	var controller_input = left_controller.get_vector2("primary").y
	if controller_input != 0.0:
		progress -= controller_input * delta
		
		if mails.size() == 0:
			printerr("mail size is 0")
			return
		
		for i in mails.size():
			if i == right_hand_picked_up_mail_index or i == left_hand_picked_up_mail_index: continue
			
			mails[i].position = calculate_mail_position(i, progress)


func calculate_mail_position(index, value):
	var mail_progress = (value + float(index) / float(mails.size()))
	mail_progress = fposmod(mail_progress, 1)
	mail_path.progress_ratio = mail_progress
	return mail_path.position + self.position


func reset_mail(index):
	var mail = mails[index]
	mail.position = calculate_mail_position(index, progress)
	mail.look_at(mail.position + Vector3.FORWARD, Vector3.UP)
	# TODO: fix mail jittering after dropping and scrolling at the same time
	# fix could involve freezing mail with reset immediately


func _on_left_hand_has_picked_up(what):
	if mails.has(what):
		left_hand_picked_up_mail_index = mails.find(what)


func _on_right_hand_has_picked_up(what):
	if mails.has(what):
		right_hand_picked_up_mail_index = mails.find(what)


func _on_right_hand_has_dropped():
	if right_hand_picked_up_mail_index != -1:
		reset_mail(right_hand_picked_up_mail_index)
		right_hand_picked_up_mail_index = -1


func _on_left_hand_has_dropped():
	if left_hand_picked_up_mail_index != -1:
		reset_mail(left_hand_picked_up_mail_index)
		left_hand_picked_up_mail_index = -1
