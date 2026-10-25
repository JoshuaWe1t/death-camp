extends Node2D

@onready var layer1: Parallax2D = $CloudLayer1
@onready var layer2: Parallax2D = $CloudLayer2
@onready var layer3: Parallax2D = $CloudLayer3

# Диапазоны базовых скоростей по X для каждого слоя (дальний, средний, ближний)
# Дальние облака обычно движутся медленнее, ближние — быстрее
@export var speed_range_1: Vector2 = Vector2(10.0, 30.0)
@export var speed_range_2: Vector2 = Vector2(35.0, 65.0)
@export var speed_range_3: Vector2 = Vector2(70.0, 120.0)

# Интервал между сменами скорости (в секундах)
@export var interval_min: float = 4.0
@export var interval_max: float = 8.0

# Длительность плавного перехода к новой скорости
@export var transition_duration: float = 2.5

func _ready() -> void:
	# Задаем начальные базовые скорости
	layer1.autoscroll = Vector2(speed_range_1.x, 0)
	layer2.autoscroll = Vector2(speed_range_2.x, 0)
	layer3.autoscroll = Vector2(speed_range_3.x, 0)
	
	# Запускаем цикл смены скоростей
	_schedule_next_speed_change()

func _schedule_next_speed_change() -> void:
	var wait_time: float = randf_range(interval_min, interval_max)
	await get_tree().create_timer(wait_time).timeout
	_change_speeds()
	_schedule_next_speed_change()

func _change_speeds() -> void:
	# Выбираем случайную скорость для каждого слоя в заданных границах
	var target_speed_1: float = randf_range(speed_range_1.x, speed_range_1.y)
	var target_speed_2: float = randf_range(speed_range_2.x, speed_range_2.y)
	var target_speed_3: float = randf_range(speed_range_3.x, speed_range_3.y)
	
	# Плавно интерполируем свойство autoscroll с помощью Tween
	var tween: Tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(layer1, "autoscroll:x", target_speed_1, transition_duration)
	tween.tween_property(layer2, "autoscroll:x", target_speed_2, transition_duration)
	tween.tween_property(layer3, "autoscroll:x", target_speed_3, transition_duration)
