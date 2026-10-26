extends HBoxContainer

@onready var name_label: RichTextLabel = $NameLabel
@onready var role_label: RichTextLabel = $RoleLabel
@onready var status_label: RichTextLabel = $StatusLabel

var lang = "eng"

func set_data(member: StaffMember) -> void:
	var full_name = member.first_name + " " + member.last_name
	
	if member.is_player:
		full_name = full_name
		modulate = Color(0.0, 0.0, 0.0, 1.0)
	else:
		modulate = Color(0.158, 0.158, 0.158, 1.0)
	
	if member.is_neutralized:
		# Оборачиваем в тег зачёркивания [s]...[/s]
		name_label.text = "[s]" + full_name + "[/s]"
		role_label.text = "[s]" + member.role + "[/s]"
		status_label.text = member.neutralization_reason
		modulate = Color(0.4, 0.4, 0.4)
	elif member.is_checked:
		name_label.text = full_name
		role_label.text = member.role
		status_label.text = "Проверен" if lang == "rus" else "Checked"
		modulate = Color(0.6, 0.6, 0.6)
	elif member.is_skipped:
		name_label.text = full_name
		role_label.text = member.role
		status_label.text = "Пропущен" if lang == "rus" else "Skipped"
		modulate = Color(0.663, 0.607, 0.239, 1.0)
	else:
		name_label.text = full_name
		role_label.text = member.role
		status_label.text = ""
