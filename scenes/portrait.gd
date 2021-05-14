extends Node2D

var _current


func set_portrait(id, emotion):
  _current = null
  for c in self.get_children():
    if c.name == id:
      c.show()
      _current = c
    else:
      c.hide()

  if emotion != null:
    change_emotion(emotion)


func change_emotion(emotion):
  if _current != null and _current.has_method("change_emotion"):
    _current.change_emotion(emotion)
