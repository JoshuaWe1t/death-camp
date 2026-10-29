extends CanvasLayer

@onready var house: Label = $Control/House
@onready var admin: Label = $Control/Admin
@onready var west_dormitory: Label = $Control/WestDormitory
@onready var east_dormitory: Label = $Control/EastDormitory
@onready var canteen: Label = $Control/Canteen
@onready var north_barrack: Label = $Control/NorthBarrack
@onready var west_barrack: Label = $Control/WestBarrack
@onready var south_barrack: Label = $Control/SouthBarrack
@onready var north_workshop: Label = $Control/NorthWorkshop
@onready var south_workshop: Label = $Control/SouthWorkshop
@onready var laboratory: Label = $Control/Laboratory
@onready var death_wall: Label = $Control/DeathWall
@onready var crematorium: Label = $Control/Crematorium
@onready var north_gas_chamber: Label = $Control/NorthGasChamber
@onready var south_gas_chamber: Label = $Control/SouthGasChamber
@onready var morgue: Label = $Control/Morgue
@onready var dispatch_station: Label = $Control/DispatchStation
@onready var hospital: Label = $Control/Hospital
@onready var infirmary: Label = $Control/Infirmary


var lang: String = Global.lang


func _ready() -> void:
	hide()
	if lang == "rus":
		house.text = BuildingDatabase.DATA.get("komendant").get("name").get("rus")
		admin.text = BuildingDatabase.DATA.get("admin").get("name").get("rus")
		west_dormitory.text = BuildingDatabase.DATA.get("dormitory").get("name").get("rus")
		east_dormitory.text = BuildingDatabase.DATA.get("dormitory1").get("name").get("rus")
		canteen.text = BuildingDatabase.DATA.get("canteen").get("name").get("rus")
		north_barrack.text = BuildingDatabase.DATA.get("barrack").get("name").get("rus")
		west_barrack.text = BuildingDatabase.DATA.get("barrack1").get("name").get("rus")
		south_barrack.text = BuildingDatabase.DATA.get("barrack2").get("name").get("rus")
		north_workshop.text = BuildingDatabase.DATA.get("workshop").get("name").get("rus")
		south_workshop.text = BuildingDatabase.DATA.get("workshop1").get("name").get("rus")
		laboratory.text = BuildingDatabase.DATA.get("laboratory").get("name").get("rus")
		death_wall.text = BuildingDatabase.DATA.get("death_wall").get("name").get("rus")
		crematorium.text = BuildingDatabase.DATA.get("crematorium").get("name").get("rus")
		north_gas_chamber.text = BuildingDatabase.DATA.get("gas_chamber").get("name").get("rus")
		south_gas_chamber.text = BuildingDatabase.DATA.get("gas_chamber1").get("name").get("rus")
		morgue.text = BuildingDatabase.DATA.get("morgue").get("name").get("rus")
		dispatch_station.text = BuildingDatabase.DATA.get("station").get("name").get("rus")
		hospital.text = BuildingDatabase.DATA.get("hospital_small").get("name").get("rus")
		infirmary.text = BuildingDatabase.DATA.get("hospital_large").get("name").get("rus")
	else:
		house.text = BuildingDatabase.DATA.get("komendant").get("name").get("eng")
		admin.text = BuildingDatabase.DATA.get("admin").get("name").get("eng")
		west_dormitory.text = BuildingDatabase.DATA.get("dormitory").get("name").get("eng")
		east_dormitory.text = BuildingDatabase.DATA.get("dormitory1").get("name").get("eng")
		canteen.text = BuildingDatabase.DATA.get("canteen").get("name").get("eng")
		north_barrack.text = BuildingDatabase.DATA.get("barrack").get("name").get("eng")
		west_barrack.text = BuildingDatabase.DATA.get("barrack1").get("name").get("eng")
		south_barrack.text = BuildingDatabase.DATA.get("barrack2").get("name").get("eng")
		north_workshop.text = BuildingDatabase.DATA.get("workshop").get("name").get("eng")
		south_workshop.text = BuildingDatabase.DATA.get("workshop1").get("name").get("eng")
		laboratory.text = BuildingDatabase.DATA.get("laboratory").get("name").get("eng")
		death_wall.text = BuildingDatabase.DATA.get("death_wall").get("name").get("eng")
		crematorium.text = BuildingDatabase.DATA.get("crematorium").get("name").get("eng")
		north_gas_chamber.text = BuildingDatabase.DATA.get("gas_chamber").get("name").get("eng")
		south_gas_chamber.text = BuildingDatabase.DATA.get("gas_chamber1").get("name").get("eng")
		morgue.text = BuildingDatabase.DATA.get("morgue").get("name").get("eng")
		dispatch_station.text = BuildingDatabase.DATA.get("station").get("name").get("eng")
		hospital.text = BuildingDatabase.DATA.get("hospital_small").get("name").get("eng")
		infirmary.text = BuildingDatabase.DATA.get("hospital_large").get("name").get("eng")


func _input(event):
	if event.is_action_pressed("SPACE"):
		print("Show hints labels")
		show()
		
	if event.is_action_released("SPACE"):
		print("Show hints labels")
		hide()
