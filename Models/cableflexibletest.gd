extends Node3D

@onready var cable_child = get_node("CableBeginning")
@onready var cable_child_2 = get_node("CableMiddle")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cable_child.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	cable_child_2.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
