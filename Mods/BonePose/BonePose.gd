extends Mod_Base
# Bone Pose
# by lunazera

@export var bone_name : String = "Tail.002"

@export var bonex : float = 0
@export var boney : float = 0
@export var bonez : float = 0

var bone_index = 0

func _ready():
	add_tracked_setting("bone_name", "Bone Name")
	add_tracked_setting(
		"bonex", "X",
		{"min" : -30.00,
		 "max" : 30.00},)
	add_tracked_setting(
		"boney", "Y",
		{"min" : -30.00,
		 "max" : 30.00},)
	add_tracked_setting(
		"bonez", "Z",
		{"min" : -30.00,
		 "max" : 30.00},)

func _process(delta: float) -> void:
	var skel = get_skeleton()
	# Check if bone index has been set first (that it found the given bone name)
	bone_index = skel.find_bone(bone_name)
	if bone_index != 0:
		# Calculate new transformation quaternion from euler rotation
		var newtransform : Quaternion = Quaternion.from_euler(Vector3(bonex*0.1, boney*0.1, bonez*0.1))
		
		# Apply bone rotation
		skel.set_bone_pose_rotation(bone_index, newtransform)
