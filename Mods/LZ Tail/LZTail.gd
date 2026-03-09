extends Mod_Base

@export var wag_speed : float = 1.0
@export var wag_amount : float = 1.0
var time : float = 0
var wag_factor : float = 0
var wag_sin : float = 0
var bone_index = 1

func _ready():
	var skel = get_skeleton()
	bone_index = skel.find_bone("Tail.001")

	add_tracked_setting(
		"wag_speed", "Speed of tail wagging",
		{"min" : 0.0,
		 "max" : 25.0})
	add_tracked_setting(
		"wag_amount", "Rotation amount of tail wagging",
		{"min" : 0.0,
		 "max" : 1.0})
		

func _process(delta: float) -> void:
	# Calculate sin function value that'll loop back and forth for swaying
	wag_factor = fmod(wag_factor + wag_speed*delta*10, 360)
	wag_sin = sin(wag_factor)
	
	var skel = get_skeleton()
	var newtransform : Quaternion = Quaternion.from_euler(Vector3(0,0,wag_sin*wag_amount))
	skel.set_bone_pose_rotation(bone_index, newtransform)
	print(wag_factor)
	print(wag_sin)
