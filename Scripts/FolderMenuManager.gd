extends Control

@onready var AD_NoteMaker = $AD_NoteMaker
@onready var AD_FolderName = $AD_FolderName
@onready var NotesList = $ColorRect/MarginContainer/VBoxContainer/VSplitContainer/HBoxContainer2/ScrollContainer/VBoxContainer

var AD_NoteMaker_Pinned = false


func _ready():
	FillNotes()
		
func _process(delta):
	if(Global.RefreshNoteList):
		FillNotes()
		Global.RefreshNoteList = false
	
		
func FillNotes():
	var Add_Note = func(index):
		var NoteTab = load("res://Prefabs/Prefab_Note.tscn").instantiate()
		NoteTab.noteIndex = index
		NotesList.add_child(NoteTab)
	for n in NotesList.get_children():
		NotesList.remove_child(n)
		n.queue_free()
	for x in range(0, len(Global.LoadedProfile["Notes"])):
		if(Global.LoadedProfile["Notes"][x]["Pinned"]):
			Add_Note.call(x)
	for x in range(0, len(Global.LoadedProfile["Notes"])):
		if(!Global.LoadedProfile["Notes"][x]["Pinned"]):
			Add_Note.call(x)

func _on_btn_new_note_pressed():
	AD_NoteMaker.visible = true
	AD_NoteMaker.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteContent").set_text("")
	AD_NoteMaker.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteName").set_text("")
	AD_NoteMaker.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/CheckBox").set_pressed(false)
	
func CreateNote(Name, Content, Pinned):
	var newNote = {
	"DateMade": "00/00/00",
	"Name": "",
	"Content": "",
	"Pinned": false,
}
	newNote["DateMade"] = Time.get_date_string_from_system()
	newNote["Name"] = Name
	newNote["Content"] = Content
	newNote["Pinned"] = Pinned
	Global.LoadedProfile["Notes"].append(newNote)
	Global.Save(Global.LoadedProfile["ProfileName"])
	print(Global.LoadedProfile["Notes"])
	FillNotes()


func _on_btn_back_pressed():
	Global.Save(Global.LoadedProfile["ProfileName"])
	Global.LoadedProfile = {}
	SceneTransition.changeScene("res://Menus/MainMenu.tscn")


func _on_ad_note_maker_canceled():
	AD_NoteMaker.visible = false

func _on_ad_note_maker_confirmed():
	AD_NoteMaker.visible = false
	var Name = AD_NoteMaker.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteName").get_text()
	AD_NoteMaker.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteName").set_text("")
	var Date = Time.get_date_string_from_system()
	var Content = AD_NoteMaker.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteContent").get_text()
	AD_NoteMaker.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteContent").set_text("")
	CreateNote(Name, Content, AD_NoteMaker_Pinned)


func _on_check_box_toggled(toggled_on):
	AD_NoteMaker_Pinned = toggled_on




func _on_ad_folder_name_confirmed():
	var tempName = AD_FolderName.get_node("TE_ProfileName").get_text()
	var warning = false
	if(tempName):
		for fname in Global.GetAllProfiles():
			if(fname == tempName):
				var Warning = load("res://Prefabs/Warning.tscn").instantiate()
				Warning.set_text("The folder needs a unique name")
				add_child(Warning)
				warning = true
		if(!warning):
			!AD_FolderName.visible
			Global.DeleteProfile(Global.LoadedProfile["ProfileName"])
			Global.LoadedProfile["ProfileName"] = tempName
			Global.Save(tempName)
	else:
		var Warning = load("res://Prefabs/Warning.tscn").instantiate()
		Warning.set_text("The Folder needs a name")
		owner.add_child(Warning)


func _on_ad_folder_name_canceled():
	AD_FolderName.visible = false


func _on_btn_editFolder_pressed():
	AD_FolderName.visible = true
	AD_FolderName.get_node("TE_ProfileName").set_text("")
