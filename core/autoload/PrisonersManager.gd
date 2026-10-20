extends Node


var total_prizoners: int
var current_prizoners: int = 400
var prisoners_souls: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("PrizonersManager is initialized")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset_prisoners_count(prisoners_count: int = 400, souls: int = 0) -> void:
	current_prizoners = prisoners_count
	prisoners_souls = souls
