extends Control


@onready var Lbl_Name = $Control/VBoxContainer/VSplitContainer/HBoxContainer/Lbl_NoteName
@onready var Lbl_DateMade = $Control/VBoxContainer/VSplitContainer/HBoxContainer/Lbl_DateMade
@onready var Lbl_Content = $Control/VBoxContainer/VSplitContainer/ScrollContainer/VBoxContainer/Lbl_NoteContent
@onready var CB_Pinned = $Control/VBoxContainer/VSplitContainer/ScrollContainer/VBoxContainer/HBoxContainer/HSplitContainer2/HSplitContainer/Btn_Pin/CB_Pin
@onready var AD_NoteEditor = $AD_NoteEditor

var noteIndex = 0
var Data
var AD_NoteEditor_Pinned = false


func _ready():
	Data = Global.LoadedProfile["Notes"][noteIndex]
	Lbl_Name.set_text(Data["Name"])
	Lbl_DateMade.set_text(Data["DateMade"])
	Lbl_Content.set_text(Data["Content"])
	CB_Pinned.set_pressed(Data["Pinned"])



func _on_btn_edit_pressed():
	AD_NoteEditor.visible = true
	var newData = Global.LoadedProfile["Notes"][noteIndex]
	AD_NoteEditor.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteName").set_text(newData["Name"])
	AD_NoteEditor.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteContent").set_text(newData["Content"])
	AD_NoteEditor.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/CB_Pinned").set_pressed(newData["Pinned"])


func _on_btn_pin_pressed():
	Global.LoadedProfile["Notes"][noteIndex]["Pinned"] = !Global.LoadedProfile["Notes"][noteIndex]["Pinned"]
	CB_Pinned.set_disabled(false)
	CB_Pinned.set_pressed(!CB_Pinned.is_pressed())
	CB_Pinned.set_disabled(true)
	Global.Save(Global.LoadedProfile["ProfileName"])
	Global.RefreshNoteList = true


func _on_btn_delete_pressed():
	if(!Global.LoadedProfile["Notes"][noteIndex]["Pinned"]):
		Global.LoadedProfile["Notes"].remove_at(noteIndex)
		Global.RefreshNoteList = true
		Global.Save(Global.LoadedProfile["ProfileName"])

func EditNote(Name, Date, Content, Pinned):
	var editedNote = {
	"DateMade": "00/00/00",
	"Name": "",
	"Content": "",
	"Pinned": false,
}
	editedNote["DateMade"] = Time.get_date_string_from_system()
	editedNote["Name"] = Name
	editedNote["DateMade"] = Date
	editedNote["Content"] = Content
	editedNote["Pinned"] = Pinned
	Global.LoadedProfile["Notes"][noteIndex] = editedNote
	Global.Save(Global.LoadedProfile["ProfileName"])
	Global.RefreshNoteList = true
	
func _on_ad_note_editor_confirmed():
	AD_NoteEditor.visible = false
	var Name = AD_NoteEditor.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteName").get_text()
	AD_NoteEditor.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteName").set_text("")
	var Date = Time.get_date_string_from_system()
	var Content = AD_NoteEditor.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteContent").get_text()
	AD_NoteEditor.get_node("VBoxContainer/ScrollContainer/VBoxContainer/VSplitContainer/VSplitContainer2/TE_NoteContent").set_text("")
	EditNote(Name, Date, Content, AD_NoteEditor_Pinned)


func _on_ad_note_editor_canceled():
	AD_NoteEditor.visible = false


func _on_check_box_toggled(toggled_on):
	AD_NoteEditor_Pinned = toggled_on
