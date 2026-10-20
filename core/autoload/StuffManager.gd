extends Node


var total_stuff: int
var current_stuff: int = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset_stuff_count(value: int = 32) -> void:
	current_stuff = value
