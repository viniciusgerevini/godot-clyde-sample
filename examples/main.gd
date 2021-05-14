extends Node2D

var _is_dialogue_in_progress = false

func _ready():
  # warning-ignore:return_value_discarded
  Dialogue.connect("dialogue_started", self, "_on_dialogue_start")
  # warning-ignore:return_value_discarded
  Dialogue.connect("dialogue_finished", self, "_on_dialogue_finish")
  # warning-ignore:return_value_discarded
  Dialogue.connect("variable_changed", self, "_on_dialogue_variable_changed")
  # warning-ignore:return_value_discarded
  Dialogue.connect("event_triggered", self, "_on_dialogue_event_triggered")


func _unhandled_input(event):
  if _is_dialogue_in_progress:
    _dialogue_input(event)
  else:
    _player_input(event)


func _player_input(event):
  if event.is_action_pressed("click"):
    $player.set_target(get_global_mouse_position())


func _dialogue_input(event):
  if event.is_action_pressed("click"):
    Dialogue.next_content()


func _on_green_interaction_area_area_clicked():
  if _is_dialogue_in_progress:
    return
  Dialogue.start_dialogue("npc#murder", { "player": $player, "npc": $green })
  Dialogue.set_variable("location", "Beach")


func _on_pink_interaction_area_area_clicked():
  if _is_dialogue_in_progress:
    return
  Dialogue.start_dialogue("mr_pink", { "player": $player, "mr_pink": $mr_pink })


func _on_red_interaction_area2_area_clicked():
  if _is_dialogue_in_progress:
    return
  Dialogue.start_dialogue("npc", { "player": $player, "npc": $red })
  Dialogue.set_variable("location", "Cave")

func _on_blue_interaction_area3_area_clicked():
  if _is_dialogue_in_progress:
    return
  Dialogue.start_dialogue("npc", { "player": $player, "npc": $blue })
  Dialogue.set_variable("location", "Dungeon")


func _on_dialogue_start(_dialogue_name):
  _is_dialogue_in_progress = true


func _on_dialogue_finish(_dialogue_name):
  _is_dialogue_in_progress = false


func _on_dialogue_variable_changed(variable_name, _value, _previous_value):
  print("variable changed: %s" % variable_name)


func _on_dialogue_event_triggered(event_name):
  match event_name:
    "kill_blue":
      $blue.queue_free()
      $blue_interaction_area3.queue_free()
    "set_english_lang":
      TranslationServer.set_locale("en")
    "set_portuguese_lang":
      TranslationServer.set_locale("pt_BR")

