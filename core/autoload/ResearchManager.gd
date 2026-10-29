# research_manager.gd (Autoload)
extends Node


var research_db = {
	"res_strength": {
		"name": {"rus": "Сила", "eng": "Strength"},
		"desc": {
			"rus": "Исследование силовых способностей человека",
			"eng": "Research into human physical power and capabilities."
		},
		"type": "research",
		"duration": 2,
		"ap_cost": 2,
		"reward": 150
	},
	"res_stamina": {
		"name": {"rus": "Выносливость", "eng": "Endurance"},
		"desc": {
			"rus": "Исследование выносливости человека",
			"eng": "Research into human physical endurance and stamina limits."
		},
		"type": "research",
		"duration": 2,
		"ap_cost": 2,
		"reward": 200
	},
	"res_mental_activity": {
		"name": {"rus": "Умственная активность", "eng": "Cognitive Capacity"},
		"desc": {
			"rus": "Исследование пределов умственной активности человека",
			"eng": "Research into the limits of human mental and cognitive function."
		},
		"type": "research",
		"duration": 2,
		"ap_cost": 2,
		"reward": 200
	},
	"exp_resistance": {
		"name": {"rus": "Сопротивление", "eng": "Resistance Testing"},
		"desc": {
			"rus": "Эксперимент по сопротивлению человека физическим и биологическим угрозам",
			"eng": "Experimental testing of human tolerance to physical and biological hazards."
		},
		"type": "experiment",
		"duration": 3,
		"ap_cost": 3,
		"reward": 250
	},
	"exp_combinatorics": {
		"name": {"rus": "Комбинаторика", "eng": "Factor Synthesis"},
		"desc": {
			"rus": "Эксперимент по комбинированию различных вредоносных факторов для человека",
			"eng": "Experimental trials combining multiple hazardous agents on human subjects."
		},
		"type": "experiment",
		"duration": 1,
		"ap_cost": 4,
		"reward": 300
	}
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
