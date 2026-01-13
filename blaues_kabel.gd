# attach this script to your cable mesh
@export_node_path("Node3D") var rope_node

func _physics_process(delta):
	if not rope_node:
		return
	var rope = get_node(rope_node)
	var count = rope.get_particle_count()
	# loop along your mesh vertices/bones and assign them to rope particles:
	for i in range(count):
		var particle = rope.get_particle(i)
		# move parts of your mesh to match particle position
		# example: skeleton.set_bone_global_pose(i,...)
