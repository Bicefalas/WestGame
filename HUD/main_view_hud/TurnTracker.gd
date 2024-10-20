extends Label

@onready var steps = $"../Steps"

var turn: int = 1

func _ready():
	update_label_text()

func add_turn():
	turn += 1
	update_label_text()
	steps.reset_steps()

func update_label_text():
	self.text = 'Turn: %s' %turn

