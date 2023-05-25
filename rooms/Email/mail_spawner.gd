extends Path3D

@export var mail_scene: PackedScene
@export var mail_amount: int

var left_controller: XRController3D
var mails: Array
var mail_path: PathFollow3D

var progress = 0.0
var left_hand_picked_up_mail_index = -1
var right_hand_picked_up_mail_index = -1
var selected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(mail_amount):
		mails.append(create_mail())
	
	mail_path = $PathFollow3D
	left_controller = get_node("/XROrigin3D/LeftHand")
	left_controller.get_node("./XRToolsFunctionPickup").has_picked_up.connect(_on_left_hand_has_picked_up)
	left_controller.get_node("./XRToolsFunctionPickup").has_dropped.connect(_on_left_hand_has_dropped)
	var right_controller = get_node("/XROrigin3D/RightHand")
	right_controller.get_node("./XRToolsFunctionPickup").has_picked_up.connect(_on_right_hand_has_picked_up)
	right_controller.get_node("./XRToolsFunctionPickup").has_dropped.connect(_on_right_hand_has_dropped)
	
	position_mails()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if left_controller == null: return
	
	var controller_input = left_controller.get_vector2("primary").y
	if controller_input != 0.0 and selected:
		progress -= controller_input * delta
		position_mails()


func create_mail():
	var mail = mail_scene.instantiate()
	
	add_child(mail)
	
	return mail


func position_mails():
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
	return mail_path.position


func reset_mail(index):
	var mail = mails[index]
	mail.position = calculate_mail_position(index, progress)
	mail.look_at(mail.global_position + Vector3.FORWARD, Vector3.UP)
	# TODO: fix mail jittering after dropping and scrolling at the same time
	# SOLUTION: fix could involve freezing mail with reset immediately


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


func _on_box_on_pointer_entered():
	selected = true


func _on_box_on_pointer_exited():
	selected = false
