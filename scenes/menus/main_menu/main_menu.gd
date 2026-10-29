extends Control

const START_GAME_SCENE: PackedScene = preload("res://scenes/intro/typewriter_scene.tscn")

@onready var main_btns: VBoxContainer = $MainBtns
@onready var start_button: TextureButton = $MainBtns/StartButton
@onready var settings_button: TextureButton = $MainBtns/SettingsButton
@onready var credits_button: TextureButton = $MainBtns/CreditsButton
@onready var settings_btns: VBoxContainer = $SettingsBtns
@onready var eng_button: TextureButton = $SettingsBtns/LangBtns/EngButton
@onready var rus_button: TextureButton = $SettingsBtns/LangBtns/RusButton
@onready var music_volume_slider: HSlider = $SettingsBtns/MusicVolumeSlider
@onready var back_button: TextureButton = $SettingsBtns/HBoxContainer/BackButton
@onready var language: Label = $SettingsBtns/Language
@onready var volume: Label = $SettingsBtns/Volume
@onready var credits_plate: VBoxContainer = $CreditsPlate
@onready var credits: RichTextLabel = $CreditsPlate/ScrollContainer/Credits
@onready var credit_back_button: TextureButton = $CreditsPlate/HBoxContainer/CreditBackButton


var music_bus_index: int
var credits_text: Dictionary = {
	"rus": """
	[center]
	[b]Разработчик[/b]
	UIDDDIT

	[b]Художник[/b]
	UIDDDIT

	[b]Музыка[/b]
	"established_plane" - syni44
	"industrial-creepy-ambience" - innov8
	"industrial-abyss-drone-paulxstretch-transformation" - kkenny101

	[b]SFX эффекты[/b]
	"typewriter" - bmaczero
	"heart beat" - rlkhafi
	[/center]
	""",
	"eng": """
	[center]
	[b]Developer[/b]
	UIDDDIT

	[b]Artist[/b]
	UIDDDIT

	[b]Music[/b]
	"established_plane" - syni44
	"industrial-creepy-ambience" - innov8
	"industrial-abyss-drone-paulxstretch-transformation" - kkenny101

	[b]Sound Effects[/b]
	"typewriter" - bmaczero
	"heart beat" - rlkhafi
	[/center]
	"""
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.start_playlist()
	
	main_btns.show()
	settings_btns.hide()
	credits_plate.hide()
	
	# 1. Получаем индекс звуковой шины
	music_bus_index = AudioServer.get_bus_index("Music")
	
	# 2. Синхронизируем положение ползунка с реальной громкостью при загрузке меню
	var current_db = AudioServer.get_bus_volume_db(music_bus_index)
	# db_to_linear переводит децибелы (от -80 до 0) обратно в линейное значение (от 0.0 до 1.0)
	music_volume_slider.value = db_to_linear(current_db) * 100.0
	
	start_button.pressed.connect(_on_start_button)
	settings_button.pressed.connect(_on_settings_button)
	credits_button.pressed.connect(_on_credits_button)
	eng_button.pressed.connect(_on_eng_button)
	rus_button.pressed.connect(_on_rus_button)
	back_button.pressed.connect(_on_back_button)
	credit_back_button.pressed.connect(_on_back_button)
	music_volume_slider.value_changed.connect(_on_music_volume_slider_value_changed)


func _process(_delta: float) -> void:
	language.text = "Язык" if Global.lang == "rus" else "Volume"
	volume.text = "Громкость" if Global.lang == "rus" else "Language"


func _on_music_volume_slider_value_changed(value: float) -> void:
	# Конвертируем значение слайдера (0-100) обратно в децибелы для движка
	var volume_in_db = linear_to_db(value / 100.0)
	
	AudioServer.set_bus_volume_db(music_bus_index, volume_in_db)
	
	# Полностью мьютим шину, если ползунок на нуле
	AudioServer.set_bus_mute(music_bus_index, value == 0)


func _on_start_button() -> void:
	get_tree().change_scene_to_packed(START_GAME_SCENE)


func _on_settings_button() -> void:
	main_btns.hide()
	settings_btns.show()


func _on_credits_button() -> void:
	main_btns.hide()
	credits_plate.show()
	credits.text = credits_text.get(Global.lang)


func _on_eng_button() -> void:
	Global.lang = "eng"


func _on_rus_button() -> void:
	Global.lang = "rus"


func _on_back_button() -> void:
	settings_btns.hide()
	credits_plate.hide()
	main_btns.show()
