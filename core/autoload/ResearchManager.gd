# research_manager.gd (Autoload)
extends Node


var research_db = {
	"res_strength": {"name": "Сила", "desc": {"eng": "", "rus": "Исследование силовых способностей человека"}, "type": "research", "duration": 2, "ap_cost": 2, "reward": 150},
	"res_stamina": {"name": "Выносливость", "desc": {"eng": "", "rus": "Исследование выносливости человека"}, "type": "research", "duration": 2, "ap_cost": 2, "reward": 200},
	"res_mental_activity": {"name": "Умственная активность", "desc": {"eng": "", "rus": "Исследование пределов умственной активности человека"}, "type": "research", "duration": 2, "ap_cost": 2, "reward": 200},
	"exp_resistance": {"name": "Сопротивление", "desc": {"eng": "", "rus": "Эксперимент по сопротивлению человека физическим и биологическим угрозам"}, "type": "experiment", "duration": 3, "ap_cost": 3, "reward": 250},
	"exp_combinatorics": {"name": "Комбинаторика", "desc": {"eng": "", "rus": "Эксперимент по комбинированию различных вредоносных факторов для человека"}, "type": "experiment", "duration": 1, "ap_cost": 4, "reward": 300}
}


var active_researches = {}

func _ready():
	EventBus.day_ended.connect(_on_day_ended)


func start_research(research_id: String) -> bool:
	if not research_db.has(research_id):
		return false
		
	if active_researches.has(research_id):
		print("Это исследование уже в процессе!")
		return false
		
	var data = research_db[research_id]
	
	# Проверка и списание очков действия
	if ActionPointsManager.spend_ap(data["ap_cost"]):
		active_researches[research_id] = data["duration"]
		EventBus.research_started.emit(research_id)
		print("Начато: ", data["name"], ". Дней до завершения: ", data["duration"])
		return true
		
	return false


func _on_day_ended(_day: int) -> void:
	var completed = []
	
	for r_id in active_researches.keys():
		active_researches[r_id] -= 1
		if active_researches[r_id] <= 0:
			completed.append(r_id)
			
	for r_id in completed:
		_complete_research(r_id)


func _complete_research(research_id: String) -> void:
	var data = research_db[research_id]
	active_researches.erase(research_id)
	
	FundsManager.current_funds += data["reward"]
	
	print("Завершено: ", data["name"], ". Получено ус. ед.: ", data["reward"])
	EventBus.research_completed.emit(research_id, data["type"])
