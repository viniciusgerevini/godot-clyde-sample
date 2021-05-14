extends Node

var _persistence = {
  "dialogues": {},
  "game_progression": {}
}


func save_dialogue_data(dialogue_name, data):
  _persistence.dialogues[dialogue_name] = data


func load_dialogue_data(dialogue_name):
  return _persistence.dialogues.get(dialogue_name, null)


func game_progression():
  return _persistence.game_progression


func set_progression(var_name, value):
  _persistence.game_progression[var_name] = value
