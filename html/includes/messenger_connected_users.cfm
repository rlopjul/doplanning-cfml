<div style="padding-bottom:3px;" class="msg_users_list">Usuarios conectados:</div>
<div spry:region="xmlUsers" id="usersList">

	<div spry:state="loading">Cargando...</div>
	<div spry:state="error">Ha ocurrido un error al cargar los usuarios</div>
	<div spry:state="ready">
	<select spry:repeatchildren="xmlUsers" size="30" style="width:100%; height:330px;" class="msg_users_list">	
		<option value="" spry:if="{@id} == connected_user_id" disabled="disabled">{user_full_name}</option>
		<option value="" spry:if="{@id} != connected_user_id">{user_full_name}</option>		
	</select>
	</div>
	
</div>