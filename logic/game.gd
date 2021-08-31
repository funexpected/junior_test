extends Control

# Этот код отвечает за процесс игры в целом

onready var level_generator = preload("res://logic/level_generator.gd").new()

onready var win_screen = $win_screen
onready var game_over_screen = $game_over_screen
onready var restart_button = $restart
onready var tween = $Tween
onready var desk = $CenterContainer/desk


var level
var game_over = false

############## INIT ######################

# Точка входа в игру. Создаем доску, связываем сигналы от доски
# и от кнопки с функциями в этом скрипте.
func _ready():
	randomize()
	desk.create_desk(consts.DESK_SIZE)
	desk.connect("cell_pressed", self, "cell_pressed")
	restart_button.connect("pressed", self, "restart")


############## GAME PROCESS ###############

# Доска умеет высылать сигнал ™cell_pressed". Мы подписались на него в _ready
func cell_pressed(is_left_btn, column, line):
	if game_over:
		return
	if !level:
		# Генерируем уровень при первом нажатии
		level = level_generator.create_level(consts.DESK_SIZE, consts.BOMB_QUANTITY, [Vector2(line, column)])
	if level[line][column] == consts.BOMB && is_left_btn:
		# Нажали на бомбу
		game_over()
		return
	var cell = desk.get_cell(column, line)
	if cell.status == consts.STATES.COLSED:
		if is_left_btn:
			# Открыли новую клетку без бомбы
			open_cell(cell, column, line)
			check_is_finish() # Может, пора закончить игру?
		else:
			# Клетка закрыта - поставили флаг сверху
			cell.show_flag()
	elif cell.status == consts.STATES.FLAG && !is_left_btn:
		# Снимаем фалг с клетки
		cell.hide_flag()


func open_cell(cell, column, line):
	cell.open(level[line][column])
	if level[line][column] == consts.EMPTY:
		# рекурсивно открываем соседние пустые клетки
		open_neighbors(line, column)


func open_neighbors(line, column):
	for neighbor in desk.get_cell_neighbors(column, line):
		if neighbor.status == consts.STATES.COLSED && level[neighbor.line][neighbor.column] == consts.EMPTY:
			var cell = desk.get_cell(neighbor.column, neighbor.line)
			open_cell(cell, neighbor.column, neighbor.line)



############# GAME FINISHED #################

func game_over():
	game_over = true
	show_bombs()
	show_game_over_screen()


func check_is_finish():
	if _is_finish():
		game_over = true
		show_win_screen()


# Все клетки отгаданы? Количество бомб равно количеству закрытых клеток?
func _is_finish():
	var closed_cells = 0
	for i in level.size():
		for j in level.size():
			var cell = desk.get_cell(j, i)
			if cell.status == consts.STATES.COLSED:
				closed_cells += 1
	return closed_cells == consts.BOMB_QUANTITY


func show_bombs():
	for i in level.size():
		for j in level.size():
			if level[i][j] == consts.BOMB:
				var cell = desk.get_cell(j, i)
				cell.show_bomb()


func show_win_screen():
	win_screen.modulate.a = 0
	win_screen.show()
	tween.interpolate_property(win_screen, "modulate:a", 0, 1, 1)
	tween.start()
	yield(tween, "tween_all_completed")
	restart_button.show()


func show_game_over_screen():
	game_over_screen.modulate.a = 0
	game_over_screen.show()
	tween.interpolate_property(game_over_screen, "modulate:a", 0, 1, 1)
	tween.start()
	yield(tween, "tween_all_completed")
	restart_button.show()


func restart():
	win_screen.hide()
	game_over_screen.hide()
	restart_button.hide()
	level = null
	desk.create_desk(consts.DESK_SIZE)
	game_over = false
