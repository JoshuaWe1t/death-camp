extends Node

# Общий склад произведенных ресурсов: { "furniture": 0, "clothes": 0 }
var resource_stock: Dictionary = {
	"furniture": 0,
	"clothes": 0
}

# Суммарно отправлено ресурсов за всю сессию/период
var total_dispatched: Dictionary = {
	"furniture": 0,
	"clothes": 0
}

# Конфигурация производства ресурсов (границы рандома и стоимость)
const PRODUCTION_CONFIG: Dictionary = {
	"furniture": {
		"name_rus": "Мебель",
		"min_yield": 5,
		"max_yield": 15,
		"ap_cost": 2,
		"required_workers": 15
	},
	"clothes": {
		"name_rus": "Одежда",
		"min_yield": 8,
		"max_yield": 20,
		"ap_cost": 2,
		"required_workers": 10
	}
}

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	# Подписываемся на сигнал отправки ресурсов из UI карты/кареты
	EventBus.resource_dispatched.connect(_on_resource_dispatched)


# Запуск производства ресурса в цехе
func produce_resource(resource_id: String) -> int:
	if not PRODUCTION_CONFIG.has(resource_id):
		push_error("Неизвестный тип ресурса: " + resource_id)
		return 0
	
	var config = PRODUCTION_CONFIG[resource_id]
	var ap_cost: int = config["ap_cost"]
	
	# Проверка и списание Action Points
	if not ActionPointsManager.spend_ap(ap_cost):
		print("Недостаточно ОД для производства!")
		return 0
	
	# Генерация случайного количества произведенной продукции
	var produced_amount: int = rng.randi_range(config["min_yield"], config["max_yield"])
	
	if not resource_stock.has(resource_id):
		resource_stock[resource_id] = 0
		
	resource_stock[resource_id] += produced_amount
	EventBus.resource_stock_updated.emit(resource_id, resource_stock[resource_id])
	
	print("Цех произвел: ", config["name_rus"], " в количестве ", produced_amount, " шт. Всего на складе: ", resource_stock[resource_id])
	return produced_amount


# Отправка ресурсов по внешнему сигналу (вызывается UI кареты/поезда)
func _on_resource_dispatched(resource_id: String, amount_to_send: int) -> void:
	if not resource_stock.has(resource_id) or resource_stock[resource_id] < amount_to_send:
		print("Недостаточно ресурсов на складе для отправки! Доступно: ", get_resource_count(resource_id))
		return
	
	# 1. Списание со склада
	resource_stock[resource_id] -= amount_to_send
	if not total_dispatched.has(resource_id):
		total_dispatched[resource_id] = 0
	total_dispatched[resource_id] += amount_to_send
	
	EventBus.resource_stock_updated.emit(resource_id, resource_stock[resource_id])
	
	# 2. Учет отправленного ресурса в активных указах руководства
	_register_dispatched_in_edicts(resource_id, amount_to_send)
	
	EventBus.resource_dispatch_completed.emit(resource_id, amount_to_send, total_dispatched[resource_id])
	print("Отправлено: ", resource_id, " x", amount_to_send, ". Учтено в заданиях.")


# Проверка активных указов и начисление прогресса
func _register_dispatched_in_edicts(resource_id: String, amount: int) -> void:
	var remaining_amount: int = amount
	
	for instance_id in EdictManager.active_edicts.keys():
		var task: Dictionary = EdictManager.active_edicts[instance_id]
		
		# Ищем указ типа "resource", требующий данный ресурс
		if task.get("production_type") == "resource" and task.get("target_id") == resource_id:
			var needed: int = task.get("required_quantity", 0) - task.get("current_quantity", 0)
			
			if needed > 0:
				var to_add: int = min(remaining_amount, needed)
				EdictManager.add_progress_to_edict(instance_id, to_add)
				remaining_amount -= to_add
				
			if remaining_amount <= 0:
				break


func get_resource_count(resource_id: String) -> int:
	return resource_stock.get(resource_id, 0)


func get_dispatched_count(resource_id: String) -> int:
	return total_dispatched.get(resource_id, 0)
