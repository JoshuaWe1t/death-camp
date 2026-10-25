class_name StaffMember
extends Resource

@export var id: int
@export var is_player: bool = false
@export var first_name: String
@export var last_name: String
@export var role: String
@export var is_checked: bool = false
@export var is_neutralized: bool = false
@export var neutralization_reason: String = ""
@export var is_skipped: bool = false


func _init(p_id: int, p_is_player: bool, p_first_name: String, p_last_name: String, p_role: String):
	id = p_id
	is_player = p_is_player
	first_name = p_first_name
	last_name = p_last_name
	role = p_role
