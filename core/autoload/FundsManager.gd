extends Node


var current_funds: int = 1200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("FundsManager is initialized")


func reset_funds_value(value: int = 1200):
	current_funds = value
