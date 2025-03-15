extends PanelContainer;

@onready var property_container=$MarginContainer/VBoxContainer;
# var property;
var fps:float;

func _ready()->void:
  Global.debug=self;
  visible=false;
  # add_debug_property("FPS",fps);

func _process(delta:float)->void:
  fps=Engine.get_frames_per_second();
  add_prop("FPS",fps,1);
  # if visible:
  #   fps="%.2f"%(1.0/delta);
  #   property.text="%s:%s=%s;"%[type_string(typeof(fps)),property.name,fps];

func _input(event:InputEvent)->void:
  if event.is_action_pressed("debug"):visible=!visible;

# func add_debug_property(title:String,value):
#   property=Label.new();
#   property_container.add_child(property);
#   property.name=title;
#   property.text="%s:%s=%s;"%[type_string(typeof(value)),property.name,value];

func add_prop(title:String,value,order):
  var target;
  target=property_container.find_child(title,true,false);
  if(!target):
    target=Label.new();
    property_container.add_child(target);
    target.name=title;
    target.text="%s:%s=%s;"%[type_string(typeof(value)),title,str(value)];
  elif(visible):
    target.text="%s:%s=%s;"%[type_string(typeof(value)),title,str(value)];
    property_container.move_child(target,order);

