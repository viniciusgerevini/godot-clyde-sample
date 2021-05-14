extends Node2D

var target = Vector2()
var velocity = Vector2()

func _unhandled_input(event):
  if event.is_action_pressed("click"):
    $player.set_target(get_global_mouse_position())


func _on_green_interaction_area_area_clicked():
  #TODO green dialogue
  pass # Replace with function body.


func _on_pink_interaction_area_area_clicked():
  #TODO pink dialogue
  pass # Replace with function body.


func _on_red_interaction_area2_area_clicked():
  #TODO red dialogue
  pass # Replace with function body.


func _on_blue_interaction_area3_area_clicked():
  #TODO blue dialogue
  pass # Replace with function body.
