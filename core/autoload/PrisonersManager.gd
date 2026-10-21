extends Node


var total_prizoners: int
var current_prisoners: int = 400
var prisoners_souls: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("PrizonersManager is initialized")


func reset_prisoners_count(prisoners_count: int = 400, souls: int = 0) -> void:
	current_prisoners = prisoners_count
	prisoners_souls = souls


func can_afford_restoration(prisoners: int) -> bool:
	if prisoners <= current_prisoners:
		return true
	
	return false


func spend_resources_for_restoration(prisoners: int) -> void:
	current_prisoners -= prisoners


func free_workers(prisoners: int) -> void:
	current_prisoners += prisoners
