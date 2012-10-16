






<cfif isDefined("correcto")>
	<cfset mensaje=correcto>
	<cfoutput>#mensaje#</cfoutput>
</cfif>


<!-------------------------------------------------------------------------------------------------------------->
	
	<tr><td>

<table width="100%" bgcolor="#FFFFFF" border="0" align="center" cellpadding="0" cellspacing="0">


	
		<form action="guardarFormulario.cfm" method="post">
			<input type="hidden" name="coddomi" value="#coddomi#">
			<input type="hidden" name="userid" value="#userid#">
		<tr>
		
		<td colspan="3"><!---<div align="center" class="styleTitulos">DATOS DE ACCESO </div>--->
		 	<table cellspacing="0" cellpadding="0" border="0">
			 <tr>
			   <td class="texto_subtitulo"><Strong>Error Report From Doplanning Project</Strong></td>
			   
			 </tr>
		    </table>
		</td>
		
		</tr>
		
		<tr>
		
		
		
		</tr>
		<tr style="height:30px;">
			<td width="30%" style="width:30%;">&nbsp;</td>
			<td width="12%" style="width:18%;">&nbsp;</td>
			<td width="58%">&nbsp;</td>
		</tr>
		<tr width="100%" height="50">
			<td></td>
			<td class="texto_morado">
			<Strong>Description&nbsp;</Strong>	</td>
			<td>
			<TEXTAREA NAME="description" ROWS=3 COLS=50></TEXTAREA>
			</td>
		</tr>
		<tr style="height:30px;">
			<td style="width:30%;">&nbsp;</td>
			<td style="width:18%;">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr width="100%" height="50">
			<td></td>
			<td class="texto_morado">
			<Strong>Stage</Strong>	</td>
			<td>
			
			<TEXTAREA NAME="scenary" ROWS=10 COLS=50></TEXTAREA>	</td>
		</tr>
		<tr style="height:30px;">
			<td style="width:30%;">&nbsp;</td>
			<td style="width:18%;">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr width="100%" height="50">
			<td></td>
			
			<td class="texto_morado">
			<Strong>Remarks</Strong></td>
			<td>
			<TEXTAREA NAME="remarks" ROWS=5 COLS=50></TEXTAREA>
			</td>
		</tr>
		<tr style="height:30px;">
			<td style="width:30%;">&nbsp;</td>
			<td style="width:18%;">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr width="100%" height="30">
			<td></td>
			<td class="texto_morado">
			<Strong>Priority</Strong> </td>
			<td class="texto_normal">
			<!---<input name="priority" type="text" value="" size="35" class="texto_normal" maxlength="30" />--->
			<select name="priority" id="priority">
			<option value="HIGH">HIGH</option>
			<option value="NORMAL" selected="selected">NORMAL</option>
			<option value="LOW">LOW</option>
			</select>
			</td>
		</tr>
		
		<tr width="100%" height="30">
			<td></td>
			<td class="texto_morado">
			<Strong>Tester</Strong>	</td>
			<td>
			<input name="tester" type="text" value="" size="35" class="texto_normal" maxlength="50" /></td>
		</tr>
		<tr width="100%" height="30">
			<td></td>
			<td class="texto_morado">
			<Strong>Solver</Strong></td>
			<td class="texto_normal">
			<input name="solver" type="text" value="" size="35" class="texto_normal" maxlength="50" />
			 </td>
		</tr>
		<tr width="100%" height="30">
			<td></td>
			<td class="texto_morado">
			<Strong>Asociated File</Strong></td>
			<td>
			<input name="associated_file" type="text" value="NONE" size="30" class="texto_normal" maxlength="50" /></td>
		</tr>
		<tr width="100%" height="30">
			<td></td>
			<td class="texto_morado">
			State</td>
			<td height="32">
			
			
			 
			   <select name="state" id state>
			  <option value="WITHOUT SOLVING" selected="selected">WITHOUT SOLVING</option>
			  <option value="IN RESOLUTION">IN RESOLUTION</option>
			  <option value="SOLVED">SOLVED</option>
				</select>
			</td>		
			</tr>
		
		<tr style="height:30px;">
			<td></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		
		<tr height="35">
		  
		  <td colspan="3" align="center">
		  <input name="send" type="submit" value="Send_Error" class="texto_boton" />
		 </td>
		  
		</tr>
		<tr  height="35">
		  
		  <td colspan="3" align="center">
		  <!---<cfinput name="insertar" type="submit" value="Insertar Usuario" />--->
		  <!---<cfif userType IS 1>
			<cfset returnPage = "gestionsocios.cfm">
		  <cfelse>
			<cfset returnPage = "gestionusuarios.cfm">
		  </cfif>
		  
		  <a href="#returnPage#"><img src="image/volver.gif" title="Pulse para volver a la gesti&oacute;n de usuarios"/></a>--->
		  </td>
		</tr>
		<tr>
			<td colspan="3" height="8"></td>
		</tr>
		</form>
	

	
</table>

	</td></tr>



<!------------------------------------------------------------------------------------------------------------->
	
			
		
		</table>
		<!---FIN DE TABLA PRODUCTOS--->
		</td>
	</tr>
</table>