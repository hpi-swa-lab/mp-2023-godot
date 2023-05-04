extends MeshInstance3D

@export var viewport: NodePath;
@onready var _viewport = get_node(viewport)

func _ready():
	var m: ShaderMaterial = mesh.surface_get_material(0);
	m.set_shader_parameter("viewport_texture", _viewport.get_texture())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
