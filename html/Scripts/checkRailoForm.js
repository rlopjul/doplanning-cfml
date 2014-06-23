function check_custom_form() { 
	if(railo_custom_form.check())
	{
		return true;
	}
	else 
	{
		return false;
	}
}
function addRailoRequiredTextInput(input_name, message) {
	railo_custom_form.addInput(input_name,true,0,14,null,message,null,null,null,null,-1);
}
function addRailoRequiredMaxLengthTextInput(input_name, message, max_length) {
	railo_custom_form.addInput(input_name,true,0,22,null,message,null,null,null,null,max_length);
}
function addRailoValidateInteger(input_name, message)
{
	railo_custom_form.addInput(input_name,false,0,8,null,message,null,null,null,null,-1);
}

function addRailoRequiredInteger(input_name, message)
{
	railo_custom_form.addInput(input_name,true,0,8,null,message,null,null,null,null,-1);
}

function addRailoValidateFloat(input_name, message)
{
	railo_custom_form.addInput(input_name,false,0,7,null,message,null,null,null,null,-1);
}

function addRailoRequiredFloat(input_name, message)
{
	railo_custom_form.addInput(input_name,true,0,7,null,message,null,null,null,null,-1);
}

function addRailoRequiredSelect(input_name, message)
{
	railo_custom_form.addInput(input_name,true,-1,14,null,message,null,null,null,null,-1);
}

function addRailoRequiredRadio(input_name, message)
{
	railo_custom_form.addInput(input_name,true,1,14,null,message,null,null,null,null,-1);
	//railo_form_62.addInput('prueba',true,1,14,null,'PROBANDO',null,null,null,null,-1);
}

function addRailoValidateDate(input_name, message)
{
	railo_custom_form.addInput(input_name,false,0,5,null,message,null,null,null,null,-1);
}

function addRailoRequiredDate(input_name, message)
{
	railo_custom_form.addInput(input_name,true,0,5,null,message,null,null,null,null,-1);
}

function addRailoValidateRegularExpression(input_name, message, required, regular_expression)
{
	railo_custom_form.addInput(input_name,required,0,13,regular_expression,message,null,null,null,null,-1);
}
function addRailoRequiredCheckBox(input_name, message) {
	railo_custom_form.addInput(input_name,true,2,14,null,message,null,null,null,null,-1);
}