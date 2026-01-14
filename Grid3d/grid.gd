@tool
extends Node3D

@export var snap_zone = load("res://addons/godot-xr-tools/objects/snap_zone.tscn")

@export var width := 5: 
	set(value):
		width = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
@export var height := 5:
	set(value):
		height = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
@export var margin := 0.2:
	set(value):
		margin = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
@export var cellSize = 0.5:
		set(value):
			cellSize = value
			if Engine.is_editor_hint() and is_inside_tree():
				_ready()
@export var orientation := "vertical": 
	set(value):
		orientation = value
		if Engine. is_editor_hint() and is_inside_tree(): 
			_ready()
@export_flags_3d_physics var cable_channel_layer := 1  # Layer für Cable Channel

func _ready() -> void:
	_remove_grid()
	_create_grid()

func _remove_grid():
	for node in get_children():
		node.queue_free()

func _create_grid():
	# h und w statt height/width als Loop-Variablen! 
	for h in range(height):
		for w in range(width):
			# StaticBody3D für Snapping
			var static_body = StaticBody3D. new()
			static_body.collision_layer = cable_channel_layer
			static_body.collision_mask = 0  # Keine Kollision mit anderen Objekten
			
			# Mesh erstellen
			var mesh = MeshInstance3D.new()
			mesh.mesh = PlaneMesh.new()
			mesh.mesh.size = Vector2(cellSize, cellSize)
			
			# CollisionShape für Snapping
			var collision_shape = CollisionShape3D.new()
			var box_shape = BoxShape3D.new()
			# BoxShape ist für BEIDE Fälle gleich, weil sie mit dem StaticBody rotiert wird
			box_shape.size = Vector3(cellSize, 0.01, cellSize)
			collision_shape.shape = box_shape
			
			var piece = snap_zone.instantiate()
			
			
			# Hierarchie aufbauen
			add_child(static_body)
			static_body.add_child(mesh)
			static_body.add_child(collision_shape)
			static_body.add_child(piece)
			
			
			# Position und Rotation basierend auf Orientierung
			if orientation == "vertical": 
				# Wand:  X = Breite, Y = Höhe
				static_body.global_position = global_position + Vector3(
					w * (cellSize + margin),
					h * (cellSize + margin),
					0
				)
				static_body.rotation_degrees = Vector3(-90, 0, 0)
			else:
				# Boden:  X = Breite, Z = Tiefe  
				static_body.global_position = global_position + Vector3(
					w * (cellSize + margin),
					0,
					h * (cellSize + margin)
				)
				# Keine Rotation für horizontale Orientierung
			
			if Engine.is_editor_hint():
				static_body.owner = get_tree().edited_scene_root
				mesh.owner = get_tree().edited_scene_root
				collision_shape.owner = get_tree().edited_scene_root
