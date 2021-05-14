extends KinematicBody2D

var _speed = 100
var _velocity = Vector2()
var _target

func _physics_process(delta):
  if _target:
    _velocity = self.position.direction_to(_target) * _speed
    if self.position.distance_to(_target) > 30:
      if _velocity.x > 0:
        $body.flip_h = false
      elif _velocity.x < 0:
        $body.flip_h = true

      $body.play("walking")

      _velocity = move_and_slide(_velocity)
    else:
      $body.play("idle")
  else:
    $body.play("idle")


func set_target(target):
  _target = target

