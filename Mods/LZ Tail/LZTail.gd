extends Mod_Base

@export var tailx : float = 0
@export var taily : float = 0
@export var tailz : float = 0

@export var wag_speed : float = 1.0
@export var wag_amount : float = 1.0

@export var wagx : bool = false
@export var wagy : bool = false
@export var wagz : bool = false

@export var tail_bone_name : String = "Tail.001"
@export var blendshape_name : String = "mouthSmileLeft"

@export var responsive_toggle : bool = false

var blendshape_value : float = 0
var blendshape_min_threshold : float = 0.4

var responsive_modifier : float = 0
var responsive_speed : float = 2
var responsive_max : float = 5

var wag_factor : float = 0
var wag_sin : float = 0
var bone_index = 0

func _ready():
	add_tracked_setting("tail_bone_name", "Name of bone you want to apply tail wag to. This should be the first bone in your tail's chain, and can't have a springbone on it.")
	
	add_setting_group("offset", "Offset rotation for your tail bone")
	add_tracked_setting(
		"tailx", "Tail X Offset",
		{"min" : -2.00,
		 "max" : 2.00},"offset")
	add_tracked_setting(
		"taily", "Tail Y Offset",
		{"min" : -2.00,
		 "max" : 2.00},"offset")
	add_tracked_setting(
		"tailz", "Tail Z Offset",
		{"min" : -2.00,
		 "max" : 2.00},"offset")

	add_tracked_setting(
		"wag_speed", "Speed of tail wagging",
		{"min" : 0.0,
		 "max" : 10.0})
		
	add_tracked_setting(
		"wag_amount", "Rotation amount of tail wagging",
		{"min" : 0.00,
		 "max" : 1.00})

	add_tracked_setting("wagx", "Apply to X rotation")
	add_tracked_setting("wagy", "Apply to Y rotation")
	add_tracked_setting("wagz", "Apply to Z rotation")
	
	add_setting_group("responsive", "Responsive Wagging")
	add_tracked_setting("responsive_toggle", "Apply responsive tail wagging", {}, "responsive")
	add_tracked_setting("blendshape_name", "Which blendshape do you want to use for your tail wagging?", {}, "responsive")
	add_tracked_setting(
		"blendshape_min_threshold", "Minimum Blendshape value for wagging increase",
		{"min" : 0.0,
		 "max" : 1.0}, "responsive")
	add_tracked_setting(
		"responsive_speed", "How fast does your wagging increase?",
		{"min" : 0.0,
		 "max" : 5.0}, "responsive")
	add_tracked_setting(
		"responsive_max", "Maximum wagging speed increase",
		{"min" : 0.0,
		 "max" : 5.0}, "responsive")

func _process(delta: float) -> void:
	var skel = get_skeleton()
	if bone_index == 0:
		bone_index = skel.find_bone(tail_bone_name)
	else:
		# Calculate responsive wagging parameter
		if responsive_toggle:
			# Get blendshape info
			var blend_shape_dict : Dictionary = get_global_mod_data("BlendShapes")
			if blend_shape_dict.has(blendshape_name):
				blendshape_value = blend_shape_dict[blendshape_name]
			else:
				blendshape_value = 0
			
			if blendshape_value > blendshape_min_threshold:
				responsive_modifier += responsive_speed*delta
				if responsive_modifier > responsive_max:
					responsive_modifier = responsive_max
			else:
				responsive_modifier -= responsive_speed*delta
				if responsive_modifier < 0:
					responsive_modifier = 0
			
		
		# add the modifier (responding to blendshape) to the wag speed value
		var wag_speed_modified = wag_speed + responsive_modifier
		# Calculate sin function value that'll loop back and forth for swaying
		wag_factor = fmod(wag_factor + wag_speed_modified*delta, 360)
		wag_sin = sin(wag_factor)*wag_amount
		
		var tailxTransform = tailx + wag_sin*int(wagx)
		var tailyTransform = taily + wag_sin*int(wagy)
		var tailZTransform = tailz + wag_sin*int(wagz)
		
		
		var newtransform : Quaternion = Quaternion.from_euler(Vector3(tailxTransform, tailyTransform, tailZTransform))
		skel.set_bone_pose_rotation(bone_index, newtransform)
