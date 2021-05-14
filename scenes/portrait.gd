extends Node2D

var _current


func set_portrait(id):
  var _current = null
  for c in self.get_children():
    if c.name == id:
      c.show()
      _current = c
    else:
      c.hide()


func change_emotion(emotion):
  if _current != null:
    _current.change_emotion(emotion)
