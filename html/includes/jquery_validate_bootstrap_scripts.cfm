<!---http://stackoverflow.com/questions/18754020/bootstrap-3-with-jquery-validation-plugin--->
// jQuery validation validator defaults for bootstrap
$.validator.setDefaults({

    highlight: function(element) {
        $(element).parent().addClass('has-error');
    },
    unhighlight: function(element) {
        $(element).parent().removeClass('has-error');
    },
    errorElement: 'span',
    errorClass: 'help-block',
    errorPlacement: function(error, element) {
        if(element.parent('.input-group').length) {
            error.insertAfter(element.parent());
        } else {
            error.insertAfter(element);
        }
    }

});