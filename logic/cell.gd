extends Control

# Скрипт одной ячейки
# Отвечает за отрисовку ее состояния

const DIGITS_PATH_TEMPLATE = "res://gfx/%s.png"
const COLORS = [Color("15bcb8"), Color("6666bc"), Color("e05c5c"), Color("3790b7"), Color("e07c38"), Color("00a589"), Color("d65caa"), Color("4eb558")]

onready var num_texture = $num
onready var closed = $closed
onready var flag = $flag
onready var btn = $btn

onready var bomb = $bomb

var status = consts.STATES.COLSED
var line
var column

signal pressed(is_left_btn)

func _ready():
	# Все события gui (движения мышки, нажатия) будут направляться в func btn_gui_input
	btn.connect("gui_input", self, "btn_gui_input")

func btn_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		# обрабатываем нажатия
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("pressed", true)
			BUTTON_RIGHT:
				emit_signal("pressed", false)

# Открыть клетку и показать цыфру на ней
func open(num: int):
	status = consts.STATES.OPEN
	closed.hide()
	if num:
		num_texture.texture = load(DIGITS_PATH_TEMPLATE % (num))
		num_texture.modulate = COLORS[num - 1]

func show_bomb():
	bomb.show()
	closed.hide()

func show_flag():
	flag.show()
	status = consts.STATES.FLAG

func hide_flag():
	flag.hide()
	status = consts.STATES.COLSED
