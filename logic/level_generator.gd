extends Reference

# Level generator
# Это отдельный скрипт, который умеет создавать уровень по заданым параметрам

func create_level(size, bombs, force_free_points = []):
	var level = []
	
	# Создаем поле
	for i in size:
		level.append([])
		for j in size:
			level[i].append(consts.EMPTY)
	assert(size * size / 4 > bombs) # too many bombs
	# Размещаем бомбы в рандомных клетках
	while bombs > 0:
		var random_point = randi() % (size * size)
		var point = Vector2(random_point % size, random_point / size)
		if point in force_free_points:
			continue
		if level[point.x][point.y] == consts.EMPTY:
			level[point.x][point.y] = consts.BOMB
			bombs -= 1
	print_level(level)
	# заполняем цифры на поле
	for i in size:
		for j in size:
			if level[i][j] != consts.BOMB:
				level[i][j] = count_bombs_neighbors(level, i, j)
	print_level(level)
	return level


func print_level(level):
	for row in level:
		print(row)


func count_bombs_neighbors(level, i, j):
	var bombs = 0
	for x in [-1, 0, 1]:
		var point_x = i + x
		if point_x < 0 || point_x >= level.size():
			continue
		for y in [-1, 0, 1]:
			var point_y = j + y
			if point_y < 0 || point_y >= level.size():
				continue
			if level[point_x][point_y] == consts.BOMB:
				bombs += 1
	return bombs



