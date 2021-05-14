extends MarginContainer

signal option_selected(option_index)

const DialogueOption = preload("res://scenes/dialogue_option.tscn")

onready var _speaker_name_field = $container/HBoxContainer/MarginContainer/char_name
onready var _text_field = $container/HBoxContainer/VBoxContainer/text
onready var _options_container = $container/HBoxContainer/VBoxContainer/options_margin/options
onready var _portrait = $container/HBoxContainer/MarginContainer/portrait


func _on_text_timer_timeout():
  if has_pending_text():
    _text_field.visible_characters += 1


func show_text():
  _text_field.visible_characters = _text_field.get_total_character_count()


func has_pending_text():
  return _text_field.visible_characters < _text_field.get_total_character_count()


func set_text(text):
  _text_field.text = text
  _text_field.visible_characters = 0
  _text_field.show()
  _options_container.hide()


func set_speaker_name(speaker_name):
  _speaker_name_field.text = speaker_name if speaker_name != null else  ""


func show_options(content):
  for o in _options_container.get_children():
    o.queue_free()

  for i in range(content.options.size()):
    var option = DialogueOption.instance()
    option.text = content.options[i].label
    _options_container.add_child(option)
    option.connect("confirm_option", self, "_on_option_selected", [ i + 1 ])

  if content.get("name") != null:
    set_text(content.name)
    show_text()

  _options_container.show()


func set_portrait(id, emotion = "idle"):
  _portrait.set_portrait(id, emotion)


func set_portrait_emotion(emotion):
  _portrait.change_emotion(emotion)


func _on_option_selected(id):
  emit_signal("option_selected", id)
