extends Node

# Используемые константы. Этот скрипт в настройках проекта отмечен как синглтон,
# и к нему есть доступ из любого скрипта через глобальную переменную consts

const CELL_SIZE = 40
const DESK_SIZE = 10
const BOMB_QUANTITY = 10
const BOMB = -1
const EMPTY = 0

# Клетка может находится в 3 состояниях:
enum STATES {
	COLSED, # Закрыта
	OPEN, # Открыта
	FLAG, # Помечена флагом
}
