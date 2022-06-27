extends MeshInstance
class_name PhaseMesh

var mat = get_surf()
var placeholder = preload("res://data/assets/cyber_background.tres")
var phase_progress = 1.0
export var phase_speed = 0.01


func _ready():
	#print("ready", name)
	phase_progress = 1.0
	material_override = load("res://data/assets/phease_shader.tres")
	material_override.set_shader_param("dissolve_amount", 0.0)
	
func _physics_process(delta):
	if material_override is ShaderMaterial:
		#print("processing")
		phase_progress -= phase_speed
		material_override.set_shader_param("dissolve_amount", phase_progress)
		if phase_progress < 0.2:
			#print("done")
			solidify()
		
func get_surf():
	if get_mesh() == null or get_mesh().get_surface_count() == 0:
		return null
	return get_mesh().surface_get_material(0)
	
func solidify():
	call_deferred("set", "material_override", null)

func phase():
	_ready()
