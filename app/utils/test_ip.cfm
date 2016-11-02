<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="isWithinCIDR" returnvariable="isIpInRange"><!---217.12.16.0-217.12.31.255--->
  <cfinvokeargument name="CIDR" value="217.12.16.0/20">
  <cfinvokeargument name="TestIP" value="#URL.ip#">
</cfinvoke>
<cfdump var="#result#">
