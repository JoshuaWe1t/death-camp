extends Node


var current_action_points: int = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('ActionPointsManagere is initialized')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset_action_points(value: int = 10) -> void:
	current_action_points = value
