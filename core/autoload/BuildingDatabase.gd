extends Node


const DATA = {
	"admin": {
		"name": {
			"rus": "Администрация",
			"eng": "Administration"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 25, "upkeep_cycle": 3
	},
	"komendant": {
		"name": {
			"rus": "Дом коменданта",
			"eng": "Komendant's house"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 25, "upkeep_cycle": 5
	},
	"dormitory": {
		"name": {
			"rus": "Общежитие персонала",
			"eng": "dormitory"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 45, "upkeep_cycle": 5
	},
	"morgue": {
		"name": {
			"rus": "Морг",
			"eng": "Morgue"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 5, "upkeep_cycle": 1
	},
	"canteen": {
		"name": {
			"rus": "Столовая",
			"eng": "Canteen"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 25, "upkeep_cycle": 1 # базовое значение (25-250)
	},
	"hospital_small": {
		"name": {
			"rus": "Больница",
			"eng": "Hospital"
		},
		"is_restored": false,
		"restore_cost": 300, "restore_time": 2, "restore_workers": 25, "restore_ap": 3,
		"upkeep_cost": 50, "upkeep_cycle": 2
	},
	"barrack": {
		"name": {
			"rus": "Барак",
			"eng": "Barrack"
		},
		"is_restored": false,
		"restore_cost": 150, "restore_time": 1, "restore_workers": 10, "restore_ap": 1,
		"upkeep_cost": 5, "upkeep_cycle": 1
	},
	"laboratory": {
		"name": {
			"rus": "Лаборатория",
			"eng": "Laboratory"
		},
		"is_restored": false,
		"restore_cost": 250, "restore_time": 3, "restore_workers": 30, "restore_ap": 3,
		"upkeep_cost": 15, "upkeep_cycle": 0 # 0 значит потребляет только при работе
	},
	"workshop": {
		"name": {
			"rus": "Цех",
			"eng": "Workshop"
		},
		"is_restored": false,
		"restore_cost": 350, "restore_time": 2, "restore_workers": 30, "restore_ap": 4,
		"upkeep_cost": 35, "upkeep_cycle": 0
	},
	"hospital_large": {
		"name": {
			"rus": "Госпиталь",
			"eng": "Infirmary"
		},
		"is_restored": false,
		"restore_cost": 400, "restore_time": 4, "restore_workers": 45, "restore_ap": 3,
		"upkeep_cost": 75, "upkeep_cycle": 3
	},
	"crematorium": {
		"name": {
			"rus": "Крематорий",
			"eng": "Crematorium"
		},
		"is_restored": false,
		"restore_cost": 250, "restore_time": 2, "restore_workers": 25, "restore_ap": 2,
		"upkeep_cost": 45, "upkeep_cycle": 5
	},
	"gas_chamber": {
		"name": {
			"rus": "Газовая камера",
			"eng": "Gas chamber"
		},
		"is_restored": false,
		"restore_cost": 300, "restore_time": 2, "restore_workers": 40, "restore_ap": 2,
		"upkeep_cost": 125, "upkeep_cycle": 0
	},
	"death_wall": {
		"name": {
			"rus": "Стена смерти",
			"eng": "Death wall"
		},
		"is_restored": false,
		"restore_cost": 50, "restore_time": 1, "restore_workers": 5, "restore_ap": 1,
		"upkeep_cost": 10, "upkeep_cycle": 0
	}
}

func get_building(id: String) -> Dictionary:
	if DATA.has(id):
		return DATA[id]
	return {}
