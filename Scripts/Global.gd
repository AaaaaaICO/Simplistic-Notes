extends Node

# Profile == Folder

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
func GetAllProfiles():
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	return config.get_sections()

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
