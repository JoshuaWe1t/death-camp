extends Node


var DATA = {
	"admin": {
		"name": {
			"rus": "Администрация",
			"eng": "Administration"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 25, "upkeep_cycle": 3,
		"description": {
			"rus": "Открывает доступ к списку штата",
			"eng": "Unlocks the Staff Roster"
		}
	},
	"komendant": {
		"name": {
			"rus": "Дом коменданта",
			"eng": "Komendant's house"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 25, "upkeep_cycle": 5,
		"description": {
			"rus": "Позволяет закончить текущий день",
			"eng": "Allows ending the current day"
		}
	},
	"dormitory": {
		"name": {
			"rus": "Западное общежитие",
			"eng": "West dormitory"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 45, "upkeep_cycle": 5,
		"description": {
			"rus": "Открывает новых сотрудников",
			"eng": "Unlocks new staff"
		}
	},
	"dormitory1": {
		"name": {
			"rus": "Восточное общежитие",
			"eng": "East dormitory"
		},
		"is_restored": false,
		"restore_cost": 100, "restore_time": 2, "restore_workers": 25, "restore_ap": 2,
		"upkeep_cost": 45, "upkeep_cycle": 5,
		"description": {
			"rus": "Открывает новых сотрудников",
			"eng": "Unlocks new staff"
		}
	},
	"morgue": {
		"name": {
			"rus": "Морг",
			"eng": "Morgue"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 0, "upkeep_cycle": 1,
		"description": {
			"rus": "Хранит погибших сотрудников/заключенных",
			"eng": "Stores deceased staff / prisoners"
		}
	},
	"canteen": {
		"name": {
			"rus": "Столовая",
			"eng": "Canteen"
		},
		"is_restored": true,
		"restore_cost": 0, "restore_time": 0, "restore_workers": 0, "restore_ap": 0,
		"upkeep_cost": 25, "upkeep_cycle": 1,
		"description": {
			"rus": "Обеспечивает питание сотрудников/заключенных",
			"eng": "Provides food for staff / prisoners"
		}
	},
	"hospital_small": {
		"name": {
			"rus": "Больница",
			"eng": "Hospital"
		},
		"is_restored": false,
		"restore_cost": 300, "restore_time": 2, "restore_workers": 25, "restore_ap": 3,
		"upkeep_cost": 50, "upkeep_cycle": 2,
		"description": {
			"rus": "Открывает доступ к исследованиям",
			"eng": "Unlocks Research"
		}
	},
	"barrack": {
		"name": {
			"rus": "Северный барак",
			"eng": "North barrack"
		},
		"is_restored": true,
		"restore_cost": 150, "restore_time": 1, "restore_workers": 10, "restore_ap": 1,
		"upkeep_cost": 5, "upkeep_cycle": 1,
		"description": {
			"rus": "Открывает доступ к организации побега заключенных",
			"eng": "Unlocks access to prisoner escapes"
		}
	},
	"barrack1": {
		"name": {
			"rus": "Западный барак",
			"eng": "West barrack"
		},
		"is_restored": false,
		"restore_cost": 150, "restore_time": 1, "restore_workers": 10, "restore_ap": 1,
		"upkeep_cost": 5, "upkeep_cycle": 1,
		"description": {
			"rus": "Открывает доступ к организации побега заключенных",
			"eng": "Unlocks access to prisoner escapes"
		}
	},
	"barrack2": {
		"name": {
			"rus": "Южный барак",
			"eng": "South barrack"
		},
		"is_restored": false,
		"restore_cost": 150, "restore_time": 1, "restore_workers": 10, "restore_ap": 1,
		"upkeep_cost": 5, "upkeep_cycle": 1,
		"description": {
			"rus": "Открывает доступ к организации побега заключенных",
			"eng": "Unlocks access to prisoner escapes"
		}
	},
	"laboratory": {
		"name": {
			"rus": "Лаборатория",
			"eng": "Laboratory"
		},
		"is_restored": false,
		"restore_cost": 250, "restore_time": 3, "restore_workers": 30, "restore_ap": 3,
		"upkeep_cost": 15, "upkeep_cycle": 0,
		"description": {
			"rus": "Открывает доступ к экспериментам",
			"eng": "Unlocks Experiments"
		}
	},
	"laboratory1": {
		"name": {
			"rus": "Лаборатория",
			"eng": "Laboratory"
		},
		"is_restored": false,
		"restore_cost": 250, "restore_time": 3, "restore_workers": 30, "restore_ap": 3,
		"upkeep_cost": 15, "upkeep_cycle": 0,
		"description": {
			"rus": "Открывает доступ к экспериментам",
			"eng": "Unlocks Experiments"
		}
	},
	"workshop": {
		"name": {
			"rus": "Южный цех",
			"eng": "South workshop"
		},
		"is_restored": false,
		"restore_cost": 350, "restore_time": 2, "restore_workers": 30, "restore_ap": 4,
		"upkeep_cost": 35, "upkeep_cycle": 0,
		"description": {
			"rus": "Открывает доступ к производству мебели/одежды",
			"eng": "Unlocks furniture / clothing production"
		}
	},
	"workshop1": {
		"name": {
			"rus": "Северный цех",
			"eng": "North workshop"
		},
		"is_restored": false,
		"restore_cost": 350, "restore_time": 2, "restore_workers": 30, "restore_ap": 4,
		"upkeep_cost": 35, "upkeep_cycle": 0,
		"description": {
			"rus": "Открывает доступ к производству мебели/одежды",
			"eng": "Unlocks furniture / clothing production"
		}
	},
	"hospital_large": {
		"name": {
			"rus": "Госпиталь",
			"eng": "Infirmary"
		},
		"is_restored": false,
		"restore_cost": 400, "restore_time": 4, "restore_workers": 45, "restore_ap": 3,
		"upkeep_cost": 75, "upkeep_cycle": 3,
		"description": {
			"rus": "Открывает доступ к исследования",
			"eng": "Grants access to research"
		}
	},
	"crematorium": {
		"name": {
			"rus": "Крематорий",
			"eng": "Crematorium"
		},
		"is_restored": false,
		"restore_cost": 250, "restore_time": 2, "restore_workers": 25, "restore_ap": 2,
		"upkeep_cost": 45, "upkeep_cycle": 5,
		"description": {
			"rus": "Позволяет утилизировать заключенных",
			"eng": "Allows prisoner liquidation"
		}
	},
	"gas_chamber": {
		"name": {
			"rus": "Северная газовая камера",
			"eng": "North gas chamber"
		},
		"is_restored": false,
		"restore_cost": 300, "restore_time": 2, "restore_workers": 40, "restore_ap": 2,
		"upkeep_cost": 125, "upkeep_cycle": 0,
		"description": {
			"rus": "Позволяет утилизировать заключенных",
			"eng": "Allows prisoner liquidation"
		}
	},
	"gas_chamber1": {
		"name": {
			"rus": "Южная газовая камера",
			"eng": "South gas chamber"
		},
		"is_restored": false,
		"restore_cost": 300, "restore_time": 2, "restore_workers": 40, "restore_ap": 2,
		"upkeep_cost": 125, "upkeep_cycle": 0,
		"description": {
			"rus": "Позволяет утилизировать заключенных",
			"eng": "Allows prisoner liquidation"
		}
	},
	"death_wall": {
		"name": {
			"rus": "Стена смерти",
			"eng": "Death wall"
		},
		"is_restored": true,
		"restore_cost": 50, "restore_time": 1, "restore_workers": 5, "restore_ap": 1,
		"upkeep_cost": 10, "upkeep_cycle": 0,
		"description": {
			"rus": "Позволяет расстреливать заключенных",
			"eng": "Allows execution of prisoners"
		}
	}
}


func get_building(id: String) -> Dictionary:
	if DATA.has(id):
		return DATA[id]
	return {}


func get_unrestored_buildings_count() -> int:
	var count = 0
	for key in DATA:
		if not DATA[key]["is_restored"]:
			count += 1
	return count
