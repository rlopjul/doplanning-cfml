
/*function mostrarActual(apartadoActual)
{
	apartadoActual = apartadoActual.toString();
	var id = "menu"+apartadoActual;
	if(document.getElementById(id) != null)
		document.getElementById(id).className = document.getElementById(id).className+" apartadoActual";
	
	var urlPag = document.location.toString();
	var len = urlPag.length;
	var pagActual = urlPag.substring(urlPag.lastIndexOf('/')+1, len);
	
	var id2 = pagActual;
	if(document.getElementById(id2) != null)
		document.getElementById(id2).className = document.getElementById(id2).className+" subapartadoActual";
		
	var id3 = pagActual+"2";
	if(document.getElementById(id3) != null)
		document.getElementById(id3).className = document.getElementById(id3).className+" paginaActual";
		
	var id4 = pagActual+"3";
	if(document.getElementById(id4) != null)
		document.getElementById(id4).className = document.getElementById(id4).className+" subpaginaActual";
		
}*/

function mostrarActual(apartadoActual)
{
	apartadoActual = apartadoActual.toString();
	var id = "menu"+apartadoActual;
	if(document.getElementById(id) != null)
		document.getElementById(id).className = document.getElementById(id).className+" apartadoActual";
	
	/*var urlPag = document.location.toString();
	var len = urlPag.length;
	var pagActual = urlPag.substring(urlPag.lastIndexOf('/')+1, len);
	
	var id2 = pagActual;
	if(document.getElementById(id2) != null)
		document.getElementById(id2).className = document.getElementById(id2).className+" subapartadoActual";
		
	var id3 = pagActual+"2";
	if(document.getElementById(id3) != null)
		document.getElementById(id3).className = document.getElementById(id3).className+" paginaActual";
		
	var id4 = pagActual+"3";
	if(document.getElementById(id4) != null)
		document.getElementById(id4).className = document.getElementById(id4).className+" subpaginaActual";*/
		
}

function codificarForm(form)
{ 
	if(form.login.value.length==0 || form.pass.value.length==0)
	{
		alert("Por favor, complete los campos.");
		return (false);
	}
	else
	{
		form.pass.readonly = true;
		var pass = form.pass.value;
		form.pass.value = "";
		var passcod = (MD5.hex_md5(pass)).toUpperCase();
		form.pass.value = passcod;
		return (true);
	}
}