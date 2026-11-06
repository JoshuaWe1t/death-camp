extends Node


const DATA: Dictionary = {
	"main_menu": {
		"rus": {
			"settings_button": {
				"normal": preload("res://assets/textures/ui/ru/lang-settings_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/lang-settings_ru2.png")
			},
			"credits_button": {
				"normal": preload("res://assets/textures/ui/ru/button_credits_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/button_credits_ru2.png")
			},
			"eng_button": {
				"normal": preload("res://assets/textures/ui/ru/lang-eng_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/lang-eng_ru2.png")
			},
			"rus_button": {
				"normal": preload("res://assets/textures/ui/ru/lang-rus_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/lang-rus_ru2.png")
			},
			"back_button": {
				"normal": preload("res://assets/textures/ui/ru/button_back_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/button_back_ru2.png")
			},
			"start_button": {
				"normal": preload("res://assets/textures/ui/ru/lang-start_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/lang-start_ru2.png")
			}
		},
		"eng": {
			"settings_button": {
				"normal": preload("res://assets/textures/ui/lang-settings1.png"),
				"pressed": preload("res://assets/textures/ui/lang-settings2.png")
			},
			"credits_button": {
				"normal": preload("res://assets/textures/ui/button_credits1.png"),
				"pressed": preload("res://assets/textures/ui/button_credits2.png")
			},
			"eng_button": {
				"normal": preload("res://assets/textures/ui/lang-eng1.png"),
				"pressed": preload("res://assets/textures/ui/lang-eng2.png")
			},
			"rus_button": {
				"normal": preload("res://assets/textures/ui/lang-rus1.png"),
				"pressed": preload("res://assets/textures/ui/lang-rus2.png")
			},
			"back_button": {
				"normal": preload("res://assets/textures/ui/button_back1.png"),
				"pressed": preload("res://assets/textures/ui/button_back2.png")
			},
			"start_button": {
				"normal": preload("res://assets/textures/ui/lang-start1.png"),
				"pressed": preload("res://assets/textures/ui/lang-start2.png")
			}
		}
	},
	"produce": {
		"rus": {
			"furniture_button": {
				"normal": preload("res://assets/textures/ui/ru/buttons-furniture_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/buttons-furniture_ru2.png")
			},
			"clothes_button": {
				"normal": preload("res://assets/textures/ui/ru/buttons-clothes_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/buttons-clothes_ru2.png")
			},
			"produce_btn": {
				"normal": preload("res://assets/textures/ui/ru/buttons-produce_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/buttons-produce_ru2.png")
			}
		},
		"eng": {
			"furniture_button": {
				"normal": preload("res://assets/textures/ui/buttons-clothes1.png"),
				"pressed": preload("res://assets/textures/ui/buttons-clothes2.png")
			},
			"clothes_button": {
				"normal": preload("res://assets/textures/ui/buttons-furniture1.png"),
				"pressed": preload("res://assets/textures/ui/buttons-furniture2.png")
			},
			"produce_btn": {
				"normal": preload("res://assets/textures/ui/buttons-produce1.png"),
				"pressed": preload("res://assets/textures/ui/buttons-produce2.png")
			}
		}
	},
	"staff_list": {
		"rus": {
			"texture": preload("res://assets/textures/ui/ru/staff_list_ru.png")
		},
		"eng": {
			"texture": preload("res://assets/textures/ui/staff_list.png")
		}
	},
	"decree": {
		"rus": {
			"texture": preload("res://assets/textures/ui/ru/decree_ru.png"),
			"admit_button": {
				"normal": preload("res://assets/textures/ui/ru/button_admit_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/button_admit_ru2.png")
			},
			"refuse_button": {
				"normal": preload("res://assets/textures/ui/ru/buttons_diclaim_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/buttons_diclaim_ru2.png")
			},
			"cancel_button": {
				"normal": preload("res://assets/textures/ui/ru/button_camcel_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/button_camcel_ru2.png")
			}
		},
		"eng": {
			"texture": preload("res://assets/textures/ui/decree.png"),
			"admit_button": {
				"normal": preload("res://assets/textures/ui/button_admit1.png"),
				"pressed": preload("res://assets/textures/ui/button_admit2.png")
			},
			"refuse_button": {
				"normal": preload("res://assets/textures/ui/button_diclaim1.png"),
				"pressed": preload("res://assets/textures/ui/button_diclaim2.png")
			},
			"cancel_button": {
				"normal": preload("res://assets/textures/ui/button_cancel1.png"),
				"pressed": preload("res://assets/textures/ui/button_cancel2.png")
			}
		}
	},
	"escape": {
		"rus": {
			"escape_button": {
				"normal": preload("res://assets/textures/ui/ru/button_rescue_esc_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/button_rescue_esc_ru2.png")
			},
			"cancel_button": {
				"normal": preload("res://assets/textures/ui/ru/button_cancel_esc_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/button_cancel_esc_ru2.png")
			}
		},
		"eng": {
			"escape_button": {
				"normal": preload("res://assets/textures/ui/button_rescue_esc1.png"),
				"pressed": preload("res://assets/textures/ui/button_rescue_esc2.png")
			},
			"cancel_button": {
				"normal": preload("res://assets/textures/ui/button_cancel_esc1.png"),
				"pressed": preload("res://assets/textures/ui/button_cancel_esc2.png")
			}
		}
	},
	"utilize": {
		"rus": {
			"utilize_button": {
				"normal": preload("res://assets/textures/ui/ru/button_utilize_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/button_utilize_ru2.png")
			},
			"cancel_button": {
				"normal": preload("res://assets/textures/ui/ru/button_cancel_esc_ru1.png"),
				"pressed": preload("res://assets/textures/ui/ru/button_cancel_esc_ru2.png")
			}
		},
		"eng": {
			"utilize_button": {
				"normal": preload("res://assets/textures/ui/button_utilize1.png"),
				"pressed": preload("res://assets/textures/ui/button_utilize2.png")
			},
			"cancel_button": {
				"normal": preload("res://assets/textures/ui/button_cancel_esc1.png"),
				"pressed": preload("res://assets/textures/ui/button_cancel_esc2.png")
			}
		}
	}
}
