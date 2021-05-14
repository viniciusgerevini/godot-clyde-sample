extends Area2D

signal area_clicked

func _on_interaction_area_mouse_entered():
  $Label.show()


func _on_interaction_area_mouse_exited():
  $Label.hide()


func _on_interaction_area_input_event(_viewport, event, _shape_idx):
  if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
    emit_signal("area_clicked")
