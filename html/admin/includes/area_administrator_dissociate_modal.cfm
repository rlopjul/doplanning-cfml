<!--- Modal Window --->
<div id="areaAdministratorDissociateModal" class="modal container fade" tabindex="-1"></div>

<script>
	
	$administratorDissociateModal = $('#areaAdministratorDissociateModal');

	function showAreaAdministratorDissociateModalModal(url){

		$administratorDissociateModal.load(url, '', function(){
		  $administratorDissociateModal.modal({width:740});
		});

	}

</script>