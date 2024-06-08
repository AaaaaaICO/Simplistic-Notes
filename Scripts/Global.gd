extends Node

# Profile == Folder
var SettingsCode = "A928aAWsklOsk..pW;WD,[pG/'G[]]"
var saveLocation = "user://saves.cfg"
var LoadedProfile = {}
var RefreshProfileList = false
var RefreshNoteList = false
var ProfileTemplate = {
	"ProfileName": "NAME",
	"DateMade": "00/00/00",
	"Notes": [],
}

var NoteTemplate = {
	"DateMade": "00/00/00",
	"Name": "",
	"Content": "",
	"Pinned": false,
}

var StartingData = {
	"ProfileName": "Read Me",
	"DateMade": "ADMIN",
	"Notes": [{
		"DateMade": "ADMIN",
		"Name": "How to delete",
		"Content": "Drag the far right side of the open button left",
		"Pinned": false,
	},
	{
		"DateMade": "ADMIN",
		"Name": "Thx for downloading",
		"Content": "Github -> https://github.com/AaaaaaICO \n Website -> To Implement",
		"Pinned": false,
	}
	],
}

func GetAllProfiles():
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	var array = config.get_sections()
	var index = array.find(SettingsCode)
	array.remove_at(index)
	return array

func CreateProfile(Name):
	LoadedProfile = ProfileTemplate
	LoadedProfile["ProfileName"] = Name
	LoadedProfile["DateMade"] = Time.get_date_string_from_system()
	Save(Name)
func Save(Profile):
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	config.set_value(Profile, "Data", LoadedProfile)
	config.save(saveLocation)
func Load(Profile):
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	LoadedProfile = config.get_value(Profile, "Data")
	return config.get_value(Profile, "Data")
func DeleteProfile(Profile):
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	config.erase_section(Profile)
	config.save(saveLocation)
func HardReset():
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	if configFile != OK:
		pass
	config.clear()
	config.save(saveLocation)
func CheckForFirstLoad():
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	print(config.get_value(SettingsCode, "Loaded"))
	print(GetAllProfiles())
	if(!config.get_value(SettingsCode, "Loaded")):
		config.set_value(StartingData["ProfileName"], "Data", StartingData)
		config.set_value(SettingsCode, "Loaded", true)
		config.save(saveLocation)
		
