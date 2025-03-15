extends Timer;

func _process(delta:float)->void:
  Global.debug.add_prop("CoyoteTimer",get_time_left(),4)
