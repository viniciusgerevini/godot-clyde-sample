extends Node

signal dialogue_started(dialogue_name)
signal dialogue_finished(dialogue_name)

signal variable_changed(variable_name, current_value, previous_value)
signal event_triggered(event_name)


var _dialogue
var _dialogue_box
var _current_dialogue
var _current_dialogue_file
var _current_dialogue_block
var _current_speakers

func start_dialogue(dialogue_name, speakers = {}):
  _current_dialogue = dialogue_name
  var dialogue_parts = dialogue_name.split("#")
  _current_dialogue_file = dialogue_parts[0]
  if dialogue_parts.size() > 1:
    _current_dialogue_block = dialogue_parts[1]

  _current_speakers = speakers
  _load_dialogue_box()
  _dialogue_box.show()
  # warning-ignore:return_value_discarded
  _dialogue_box.connect("option_selected", self, "_on_option_selected")
  _dialogue = ClydeDialogue.new()

  if dialogue_parts.size() == 2:
    _dialogue.load_dialogue(_current_dialogue_file, _current_dialogue_block)
  else:
    _dialogue.load_dialogue(_current_dialogue_file)

  _load_data(dialogue_name, speakers)

  # warning-ignore:return_value_discarded
  _dialogue.connect("event_triggered", self, "_notify_event_triggered")
  # warning-ignore:return_value_discarded
  _dialogue.connect("variable_changed", self, "_notify_variable_changed")


  emit_signal("dialogue_started", dialogue_name)
  next_content()


func next_content():
  if _dialogue_box.has_pending_text():
    _dialogue_box.show_text()
    return

  var content = _dialogue.get_content()
  if content == null:
    _finish_dialogue()
  elif content.type == "options":
    _dialogue_box.set_options(content)
    _set_speaker_info(content)
  else:
    _dialogue_box.set_text(content.text)
    _set_speaker_info(content)


func _finish_dialogue():
  Persistence.save_dialogue_data(_current_dialogue, _dialogue.get_data())
  emit_signal("dialogue_finished", _current_dialogue)
  _dialogue_box.hide()
  # warning-ignore:return_value_discarded
  _dialogue_box.disconnect("option_selected", self, "_on_option_selected")
  _current_dialogue = null
  _current_dialogue_file = null
  _current_dialogue_block = null


func _set_speaker_info(content):
  if _current_speakers.has(content.speaker):
    var speaker = _current_speakers[content.speaker]
    _dialogue_box.set_speaker_name(speaker.character_name)
    _dialogue_box.set_portrait(speaker.id)
  else:
    _dialogue_box.set_speaker_name(content.speaker)
    _dialogue_box.set_portrait(content.speaker)

  if content.tags:
    if content.tags.has("sad"):
      _dialogue_box.set_portrait_emotion("sad")


func _load_dialogue_box():
  for c in get_tree().get_nodes_in_group("dialogue_container"):
    _dialogue_box = c
    break


func _load_data(dialogue_name, speakers):
  var data = Persistence.load_dialogue_data(dialogue_name)
  if data != null:
    _dialogue.load_data(data)

  for speaker in speakers:
    _dialogue.set_variable("%s_pronoun" % speaker, speakers[speaker].pronoun)
    _dialogue.set_variable("%s_name" % speaker, speakers[speaker].character_name)

  var progression = Persistence.game_progression()
  for var_name in progression:
    _dialogue.set_variable("progression_%s" % var_name, progression[var_name])


func set_variable(var_name, value):
  _dialogue.set_variable(var_name, value)


func get_variable(var_name):
  return _dialogue.get_variable(var_name)


func _notify_variable_changed(variable_name, value, previous_value):
  if variable_name.begins_with("progression_"):
    Persistence.set_progression(variable_name.replace("progression_", ""), value)

  emit_signal("variable_changed", variable_name, value, previous_value)


func _notify_event_triggered(event_name):
  emit_signal("event_triggered", event_name)


func _on_option_selected(option_index):
  _dialogue.choose(option_index)
  next_content()
