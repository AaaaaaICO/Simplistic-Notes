extends Panel

var ProfileName = ""

func _on_btn_open_pressed():
	Global.Load(ProfileName)
	SceneTransition.changeScene("res://Menus/FolderMenu.tscn")


func _on_btn_delete_pressed():
	Global.RefreshProfileList = true
	Global.DeleteProfile(ProfileName)
