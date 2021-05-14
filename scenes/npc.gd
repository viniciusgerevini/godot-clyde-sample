extends AnimatedSprite

export (String) var id
export (String) var character_name
export (String, "F", "M") var pronoun = "F"

func change_emotion(emotion):
  if self.has_node("head"):
    if $head.frames.has_animation(emotion):
      $head.play(emotion)
    else:
      $head.play("idle")

