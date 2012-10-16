var App; if (!App) App = {};

if (!App.UploadFile) App.UploadFile = {};

App.UploadFile.onSubmitForm = function()
{
	Spry.$("initState").style.display = "none";
	Spry.$("uploadingState").style.display = "block";

	return true;	
}

App.UploadFile.setFile = function(folder_id, name, description)
{
	Spry.$("nameInput").value = name;
	Spry.$("descriptionInput").value = description;
}

App.UploadFile.setState = function()
{
	
}