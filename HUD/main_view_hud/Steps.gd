extends Label

var steps: int = 7

func _ready():
	update_label_text()

func reset_steps():
	steps = 7
	update_label_text()

func substract_steps():
	steps -= 1
	update_label_text()

func update_label_text():
	self.text = 'Steps: %s' %steps
