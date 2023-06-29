extends StaticBody3D
class_name GazeTarget


var outline_shader = preload("res://shaders/Outline.gdshader")
var shader_mat: ShaderMaterial


func _ready():
	add_outline($MeshInstance3D)


func add_outline(meshInstance: MeshInstance3D):
	var mesh = meshInstance.mesh
	var material = mesh.material
	if not material:
		material = StandardMaterial3D.new()
		mesh.material = material
	shader_mat = ShaderMaterial.new()
	shader_mat.shader = outline_shader
	shader_mat.set_shader_parameter("color", Color("ff001e"))
	shader_mat.set_shader_parameter("border_width", 0.0)
	material.next_pass = shader_mat


func remove_outline(meshInstance: MeshInstance3D):
	var mesh = meshInstance.mesh
	if mesh.material and mesh.material.next_pass:
		mesh.material.next_pass = null


func on_focus_active():
	shader_mat.set_shader_parameter("border_width", 0.1)
	
func on_focus_inactive():
	shader_mat.set_shader_parameter("border_width", 0.0)
	
func highlight(perc: float):
	shader_mat.set_shader_parameter("border_width", 0.05 * perc)
