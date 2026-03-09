extends Mod_Base

@export var wag_speed : float = 1.0

func _ready():
	var skel = get_skeleton()
	var tail_control_index = skel.find_bone("Tail.001")
	var tail_transform = get_bone_transform("Tail.001")
	var newtransform : Quaternion = Quaternion.from_euler(Vector3(0,0,0.5))

	add_tracked_setting(
		"wag_speed", "Speed of tail wagging",
		{"min" : 0.0,
		 "max" : 25.0})
		

	# We apply a transform to our chosen bone by referencing the skeleton, getting the index of the bone by name, then using "set bone pose rotation" to apply rotation
	# If we want to do a tail wagging thing, this would be in an update loop, and we'd calculate a new transform every frame
	# Vector 3 values go 0 to 1, so radians?
	skel.set_bone_pose_rotation(tail_control_index, newtransform)
