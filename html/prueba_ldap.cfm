<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<!---<cfldap	server="10.72.32.3" dn="DC=Areanorte" username="formacion@areanorte" password="formacion" action="query" name="getUser" start="OU=Usuarios.Areanorte,DC=AREANORTE" scope="subtree" attributes="*" filter="(samaccountname=formacion)">
LDAP 1:
<cfdump var="#getUser#">

<cfloop query="getUser">
<!---<cfoutput>
#uid#<br />
#userPassword#
</cfoutput>--->
</cfloop>

<!---<cfldap server="10.72.32.11" username="formacion@AREANORTE" password="formacion" action="query" name="getUsers" start="OU=Usuarios.Areanorte,DC=AREANORTE" scope="onelevel" attributes="*">--->
<cfldap server="10.72.32.11" username="formacion@areanorte" password="formacion" action="query" name="getUsers" start="OU=Usuarios.Areanorte,DC=AREANORTE" scope="subtree" attributes="*" filter="(mail=julior.lopez.sspa@juntadeandalucia.es)">
LDAP 2:
<cfdump var="#getUsers#">--->

<!---<cfldap	server="10.72.32.3" dn="DC=Areanorte" username="formacion@areanorte" password="formacion" action="query" name="getUser" start="OU=Usuarios.Areanorte,DC=AREANORTE" scope="subtree" attributes="*" filter="(&(mail=julior.lopez.sspa@juntadeandalucia.es)(userPrincipalName=jlopezg@AREANORTE))">--->

<!---<cfldap	server="10.72.32.3" dn="DC=Areanorte" username="formacion@areanorte" password="formacion" action="query" name="getUser" start="OU=Usuarios.Areanorte,DC=AREANORTE" scope="subtree" attributes="*" filter="(mail=fernandoj.roa.sspa@juntadeandalucia.es)">

<cfdump var="#getUser#">--->


<!---<cfldap	server="10.75.2.64" username="pozoblanco@diraya" password="pozoblancoo" action="query" name="getUser" start="dc=diraya.sspa.junta-andalucia.es" attributes="*"> --->
<!---<cfldap	server="10.75.2.64" username="pozoblanco@diraya" password="pozoblanco" action="query" name="getUser" start="dc=diraya.sspa.junta-andalucia.es" attributes="*" filter="userPrincipalName=pozoblanco">

<cfdump var="#getUser#">

<cfldap	server="10.75.2.64" username="pozoblanco@diraya" password="pozoblanco" action="query" name="getUser2" start="dc=diraya.sspa.junta-andalucia.es" attributes="*" filter="sAMAccountName=pozoblanco@diraya">

<cfdump var="#getUser2#">--->

<!---<cfldap	server="10.72.32.3" dn="DC=Areanorte" username="formacion@areanorte" password="formacion" action="query" name="getUser" start="OU=Usuarios.Areanorte,DC=AREANORTE" scope="subtree" attributes="*" filter="(mail=fernandoj.roa.sspa@juntadeandalucia.es)">

<cfdump var="#getUser#">--->

<cfldap	server="10.75.2.64" username="pozoblanco@diraya" password="pozoblanco" action="query" name="getUser" start="dc=diraya.sspa.junta-andalucia.es" attributes="*" filter="(samaccountname=pozoblanco)">

<cfdump var="#getUser#">

</body>
</html>
