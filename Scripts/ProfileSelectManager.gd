extends VBoxContainer

@onready var FolderList = $VSplitContainer/HBoxContainer2/MarginContainer/ScrollContainer/VBoxContainer
@onready var Logo = $VSplitContainer/VBoxContainer/HBoxContainer/Control/CenterContainer/Sprite2D
@onready var AD_FolderName = $VSplitContainer/VBoxContainer/MarginContainer/AD_CreateFolder/VBoxContainer/MarginContainer/TextEdit
@onready var ADCreateFolder = $VSplitContainer/VBoxContainer/MarginContainer/AD_CreateFolder
func _ready():
	FillProfiles()

func _process(delta):
	if(Global.RefreshProfileList):
		FillProfiles()
		Global.RefreshProfileList = false
func FillProfiles():
	for n in FolderList.get_children():
		FolderList.remove_child(n)
		n.queue_free()
	var Profiles = Global.GetAllProfiles()
	for folder in Profiles:
		var Data = Global.Load(folder)
		var Profile = load("res://Prefabs/Prefab_ProfileSelect.tscn").instantiate()
		Profile.get_node("Control/HBoxContainer/HSplitContainer2/HSplitContainer/VBoxContainer/ProfileName").set_text(folder)
		Profile.get_node("Control/HBoxContainer/HSplitContainer2/HSplitContainer/VBoxContainer/HBoxContainer/ProfileMade").set_text(Data["DateMade"])
		Profile.get_node("Control/HBoxContainer/HSplitContainer2/HSplitContainer/VBoxContainer/HBoxContainer/NoteCount").set_text(str(len(Data["Notes"])) + " Notes")
		Profile.ProfileName = folder
		$VSplitContainer/HBoxContainer2/MarginContainer/ScrollContainer/VBoxContainer.add_child(Profile)

func _on_btn_exit_pressed():
	get_tree().quit()


func _on_btn_create_folder_pressed():
	ADCreateFolder.visible = true
	


func _on_ad_create_folder_canceled():
	ADCreateFolder.visible = false


func _on_ad_create_folder_confirmed():
	var Name = AD_FolderName.get_text()
	if(Name):
		for fname in Global.GetAllProfiles():
			if(fname == Name):
				var Warning = load("res://Prefabs/Warning.tscn").instantiate()
				Warning.set_text("The folder needs a unique name")
				owner.add_child(Warning)
				break
		!ADCreateFolder.visible
		Global.CreateProfile(Name)
		AD_FolderName.set_text("")
		FillProfiles()
	else:
		var Warning = load("res://Prefabs/Warning.tscn").instantiate()
		Warning.set_text("The Folder needs a name")
		owner.add_child(Warning)

func _on_v_split_container_Logo_dragged(offset):
	if(offset <= 200):
		Logo.visible = false
	else:Logo.visible = true
		
