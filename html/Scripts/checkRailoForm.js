function check_custom_form() 
{ 
	if(railo_custom_form.check())
	{
		return true;
	}
	else 
	{
		return false;
	}
}

function addRailoRequiredTextInput(input_name, message)
{
	railo_custom_form.addInput(input_name,true,0,14,null,message,null,null,null,null,-1);
}

function addRailoRequiredMaxLengthTextInput(input_name, message, max_length)
{
	railo_custom_form.addInput(input_name,true,0,22,null,message,null,null,null,null,max_length);
}

function addRailoRequiredCheckBox(input_name, message)
{
	railo_custom_form.addInput(input_name,true,2,14,null,message,null,null,null,null,-1);
	//addInput('sectors[]',false,2,14,null,'Debe seleccionar al menos un sector',null,null,null,null,-1);
}
