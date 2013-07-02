

<!--- 
<cfldap	server="10.201.79.21" username="DMSAS\lucenaalexis21K" password="allugi3946" action="query" scope="subtree" name="getUser" attributes="cn" start="DC=DMSAS" filter="(1=1)">

<cfdump var="#getUser#"> --->



<cfldap	server="10.75.2.64" username="allugi3946@diraya" password="allugi3946" action="query" name="getUser" start="dc=diraya.sspa.junta-andalucia.es" attributes="*" filter="(1=1)">

<cfdump var="#getUser#">
