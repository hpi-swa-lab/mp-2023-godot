extends Node

var shell: Shell

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
var outline_shader = preload("res://shaders/Outline.gdshader")
	
func add_outline(meshInstance: MeshInstance3D):
	var mesh = meshInstance.mesh
	var material = mesh.material
	if not material:
		material = StandardMaterial3D.new()
		mesh.material = material
	var shader_mat = ShaderMaterial.new()
	shader_mat.shader = outline_shader
	shader_mat.set_shader_parameter("color", Color("ff001e"))
	shader_mat.set_shader_parameter("border_width", 0.1)
	material.next_pass = shader_mat

func remove_outline(meshInstance: MeshInstance3D):
	var mesh = meshInstance.mesh
	if mesh.material and mesh.material.next_pass:
		mesh.material.next_pass = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
