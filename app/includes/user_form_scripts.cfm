<cfoutput>

<script src="#APPLICATION.ckeditorJSPath#"></script>
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
<!---<script src="#APPLICATION.htmlPath#/scripts/tablesFunctions.js?v=2.2"></script>--->
<script src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

<!---bootstrap-select--->
<link href="#APPLICATION.path#/libs/bootstrap-select/1.11.2/css/bootstrap-select.min.css" rel="stylesheet">
<script src="#APPLICATION.path#/libs/bootstrap-select/1.11.2/js/bootstrap-select.min.js"></script>

<script>

	$(function () {

	    $('##updateUserData').fileupload({
	        dataType: 'text',
	        autoUpload: false,
	        replaceFileInput: false,
	        fileInput: $('##file'),
	        forceIframeTransport: true, //Required to enable upload in IE
	        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
	        maxFileSize: 5000000, // 5 MB
	        previewMaxWidth: 400,
    		previewMaxHeight: 400,
    		previewCrop: true, // Force cropped images
    		add: function (e, data) {

    			window.URL = window.URL || window.webkitURL;

    			if(window.URL !== undefined){
    				$('##userImage').attr('src', window.URL.createObjectURL(data.files[0]));
	        		$('##deleteImageButton').hide();
    			}

	        }

	    });/*.on('fileuploadprocessalways', function (e, data) {
		    var index = data.index,
		        file = data.files[index],
		        node = $(data.context.children()[index]);
		    if (file.preview) {
		      node
		        .prepend('<br/>')
		        .prepend(file.preview)
		    }
		    if (file.error) {
		      node
		        .append('<br/>')
		        .append($('<span class="text-danger"/>').text(file.error));
		    }
		});*/

	 	$('##telephone').mask('000000000');
	 	$('##mobile_phone').mask('000000000');

	 	$('##telephone_ccode').mask('0000');
	 	$('##mobile_phone_ccode').mask('0000');

	 	<cfif APPLICATION.showDniTitle IS true>
	 	$("##dni").mask('00000000A');
	 	</cfif>

	});

</script>

</cfoutput>
