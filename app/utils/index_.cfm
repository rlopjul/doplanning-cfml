<cfif SESSION.client_administrator EQ SESSION.user_id>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>DoPlanning</title>
</head>

<body>

<strong>IMPORTACIÓN DE USUARIOS</strong>

<p>Para la importación de usuarios es necesario seguir los siguientes pasos:</p>

<a href="import/import_1_users_from_csv.cfm" target="_blank">1º Cargar desde un CSV los usuarios.</a><br/><br/>

<a href="import/import_2_users_to_doplanning.cfm" target="_blank">2º Crear los usuarios cargados en DoPlanning.</a><br/><br/>

<p>Una vez realizados los pasos anteriores correctamente, comprobar que los usuarios aparecen creados en la aplicación.</p>


</body>
</html>
</cfif>