extends Label

signal confirm_option


func _on_option_mouse_entered():
  self.modulate = Color("#eae481")


func _on_option_mouse_exited():
  self.modulate = Color("#ffffff")


func _on_option_gui_input(event):
  if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
    emit_signal("confirm_option")
