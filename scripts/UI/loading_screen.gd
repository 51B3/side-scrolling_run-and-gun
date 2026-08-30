extends Control


signal scene_loaded(scene: PackedScene)
signal loading_failed(error_message: String)

@onready var progress_bar:   ProgressBar = $VBoxContainer/ProgressBar
@onready var status_label:   Label = $VBoxContainer/status_label
@onready var tip_label:      Label = $VBoxContainer/tip_label
@onready var progress_label: Label = $VBoxContainer/progress_label
@onready var loading_timer:  Timer = $loading_timer
@onready var tip_timer:      Timer = $tip_timer # 

var scene_path:        String = ""
var loading_progress:  Array[float] = []
var tips:              Array[String] = [
	"Совет: Изучайте окружение внимательно",
	"Совет: Сохраняйте ресурсы и здоровье",
	"Совет: Исследуйте каждый уголок уровня",
	"Совет: Некоторые секреты хорошо спрятаны",
	"Совет: Используйте окружение в свою пользу",
	"Совет: Не забывайте сохраняться",
	"Совет: Экспериментируйте с разными подходами"
]


"""
func _ready() -> void:
	loading_failed.connect(_on_loading_failed)
"""


func load_scene(path: String) -> void:
	if not path:
		loading_failed.emit("Scene path is empty")
		
		return
	
	scene_path = path #
	
	if not ResourceLoader.exists(scene_path):
		loading_failed.emit("Scene not found: " + scene_path)
		
		return
	
	if progress_label:
		progress_label.text = "0%"
	
	if status_label:
		status_label.text = "Подготовка к загрузке..."
	
	var error = ResourceLoader.load_threaded_request(
		scene_path,
		"PackedScene",
		true
	)
	
	if error != OK:
		loading_failed.emit(
			"Failed to start threaded loading: " + str(error)
		)
		
		return
	
	if status_label:
		status_label.text = "Загрузка ресурсов..."
	
	loading_timer.start()
	tip_timer.start()
	loading_timer.timeout.connect(_poll_loading_status)
	tip_timer.timeout.connect(func(): tip_label.text = tips.pick_random())


func _poll_loading_status() -> void:
	match ResourceLoader.load_threaded_get_status(scene_path, loading_progress):
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var progress_percent = loading_progress[0] * 100.0
			
			if status_label:
				status_label.text = "Загрузка ресурсов: %.1f%%" % progress_percent
			
			_update_visuals(progress_percent)
		ResourceLoader.THREAD_LOAD_LOADED:
			loading_timer.stop()
			tip_timer.stop()
			_update_visuals(100.0)
			
			if status_label:
				status_label.text = "Загрузка завершена!"
			
			_finish_loading(
				ResourceLoader.load_threaded_get(scene_path)
			)
		ResourceLoader.THREAD_LOAD_FAILED:
			loading_timer.stop()
			tip_timer.stop()
			loading_failed.emit("Failed to load scene: " + scene_path)
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			loading_timer.stop()
			tip_timer.stop()
			loading_failed.emit("Invalid resource: " + scene_path)


func _update_visuals(progress_percent: float) -> void:
	if progress_label:
		progress_label.text = "%d%%" % int(progress_percent)
	
	if progress_bar:
		progress_bar.value = progress_percent


func _finish_loading(loaded_scene: PackedScene) -> void:
	await get_tree().create_timer(0.3).timeout
	
	if status_label:
		status_label.text = "Готово!"
	
	scene_loaded.emit(loaded_scene)


func _on_loading_failed(error_message: String) -> void:
	if status_label:
		status_label.text = "Ошибка загрузки: " + error_message
		status_label.modulate = Color.RED
	
	"""
	retry_button.show()
	retry_button.pressed.connect(get_tree().reload_current_scene)
	"""
