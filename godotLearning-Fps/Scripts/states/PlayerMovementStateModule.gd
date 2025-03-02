class_name PlayerMovementStateModule;
extends State;

var PLAYER:Player;
var ANIMATION:AnimationPlayer;

func _ready()->void:
  await owner.ready;
  PLAYER=owner as Player;
  ANIMATION=PLAYER.ANIMATION_PLAYER;

func _process(delta:float)->void:
  pass;
