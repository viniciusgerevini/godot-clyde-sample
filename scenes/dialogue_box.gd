extends MarginContainer

signal next_content_requested
signal option_selected(option_index)

const DialogueOption = preload("res://scenes/dialogue_option.tscn")

onready var _speaker_name_field = $container/HBoxContainer/MarginContainer/char_name
onready var _text_field = $container/HBoxContainer/VBoxContainer/text
onready var _options_container = $container/HBoxContainer/VBoxContainer/options_margin/options
onready var _portrait = $container/HBoxContainer/MarginContainer/portrait

var has_options_available = false

func _on_text_timer_timeout():
  if has_pending_text():
    _text_field.visible_characters += 1
  elif has_options_available:
    _options_container.modulate.a = 1


func show_text():
  _text_field.visible_characters = _text_field.get_total_character_count()


func has_pending_text():
  return _text_field.visible_characters < _text_field.get_total_character_count()


func set_text(text):
  _text_field.text = text
  _text_field.visible_characters = 0
  _text_field.show()
  _options_container.hide()
  has_options_available = false


func set_speaker_name(speaker_name):
  _speaker_name_field.text = speaker_name if speaker_name != null else  ""


func set_options(content):
  for o in _options_container.get_children():
    o.queue_free()

  for i in range(content.options.size()):
    var option = DialogueOption.instance()
    option.text = content.options[i].label
    _options_container.add_child(option)
    option.connect("confirm_option", self, "_on_option_selected", [ i ])

  if content.get("name") != null:
    set_text(content.name)

  _options_container.show()
  _options_container.modulate.a = 0
  has_options_available = true


func set_portrait(id, emotion = "idle"):
  _portrait.set_portrait(id, emotion)


func set_portrait_emotion(emotion):
  _portrait.change_emotion(emotion)


func _on_option_selected(id):
  emit_signal("option_selected", id)

func _gui_input(event):
  if has_options_available:
    return

  if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
    emit_signal("next_content_requested")
