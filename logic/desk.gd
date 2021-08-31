extends Control

# Этот скрипт отвечает за отображение игрового поля. Он создает игровые клетки и
# обеспечивает к ним простой доступ скрипту game.gd

var CELL_TEMPLATE = preload("res://logic/cell.tscn")

var cell_array = [] # кэшируем расположение клеток
signal cell_pressed(is_left_btn, column, line) # регестрируем сигнал, на который подпишется game.gd

# Создаем поле из элементов CELL_TEMPLATE
func create_desk(desk_size: int):
	clear_desk()
	for line in desk_size:
		cell_array.append([])
		for column in desk_size:
			var cell = CELL_TEMPLATE.instance()
			add_child(cell)
			cell.rect_position = Vector2(consts.CELL_SIZE * column, consts.CELL_SIZE * line)
			cell_array[line].append(cell)
			cell.column = column
			cell.line = line
			# при нажатии на ячейку будет вызвана функция cell_pressed_func в этом скрипте
			cell.connect("pressed", self, "cell_pressed_func", [column, line])

# Очищаем доску при рестарте игры
func clear_desk():
	cell_array = []
	for child in get_children():
		child.set_parent(null)
		child.queue_free()

# Удобный доступ к клетке по ее адресу
func get_cell(column, line):
	return cell_array[line][column]

# Получаем массив из соседей клетки (до 8 соседей)
func get_cell_neighbors(column, line):
	var neighbors = []
	for x in [-1, 0, 1]:
		var point_x = line + x
		if point_x < 0 || point_x >= cell_array.size():
			continue
		for y in [-1, 0, 1]:
			var point_y = column + y
			if point_y < 0 || point_y >= cell_array.size() || (!x && !y):
				continue
			neighbors.append(cell_array[point_x][point_y])
	return neighbors

# Все сигналы о нажатии ячейки собираются в один, в который добавляется адрес ячейки
# На этот сигнал подписан game.gd
func cell_pressed_func(is_left_btn, column, line):
	emit_signal("cell_pressed", is_left_btn, column, line)
	
