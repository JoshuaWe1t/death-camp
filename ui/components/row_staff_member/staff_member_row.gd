extends HBoxContainer

@onready var name_label = $NameLabel
@onready var role_label = $RoleLabel
@onready var status_label = $StatusLabel

func set_data(member: StaffMember) -> void:
	var full_name = member.first_name + " " + member.last_name
	
	if member.is_player:
		full_name = "[ВЫ] " + full_name
		modulate = Color(0.8, 1.0, 0.8) # Легкая зеленая подсветка строки игрока
		
	name_label.text = full_name
	role_label.text = member.role
	
	if member.is_neutralized:
		status_label.text = member.neutralization_reason
		modulate = Color(0.4, 0.4, 0.4) # Делаем нейтрализованных блеклыми
		# Если используешь RichTextLabel вместо обычного Label, можно использовать BBCode [s]Текст[/s] для зачеркивания
	elif member.is_checked:
		status_label.text = "Проверен"
		modulate = Color(0.6, 0.6, 0.6)
	elif member.is_skipped:
		status_label.text = "Пропущен"
		modulate = Color(0.663, 0.607, 0.239, 1.0)
	else:
		status_label.text = ""
