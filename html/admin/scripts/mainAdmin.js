function resizeIframe() {
  var newHeight = windowHeight()-78;
  $(".iframes").height(newHeight);

  var userIframeHeight = 300;

  $("#areaIframe").height(newHeight-userIframeHeight-5)
  $("#allUsersIframe").height(newHeight-userIframeHeight-5);
  $("#logItemIframe").height(newHeight);
  $("#treeContainer").height(newHeight-80);

  $("#usersGeneralIframe").height(newHeight-36);

  $("#typologiesUsersIframe").height(newHeight-36);
  $("#typologiesFilesIframe").height(newHeight-36);

  $("#statisticsGeneralIframe").height(newHeight-36);
  $("#statisticsUsersIframe").height(newHeight-36);
  $("#statisticsFilesIframe").height(newHeight-36);

  $("#entitiesIframe").height(newHeight-36);
}

function changeLanguage() {

  if(selectedLanguage == 'en')
    newLanguage = 'es';
  else
    newLanguage = 'en';

  window.lang.change(newLanguage);

  location.href = "../language_selection.cfm?lan="+newLanguage+"&rpage=admin/";

}

function treeLoaded() {

  if ( !isNaN(selectAreaId) ) { //Hay área para seleccionar

    selectTreeNode(selectAreaId);

  }else if( isNaN(selectAreaId) ) { //No hay area para seleccionar

    emptyIframes();
  }

  $("#loadingContainer").hide();
  $("#treeContainer").css('visibility', 'visible');

  if($("#mainContainer").is(":hidden"))
    $("#mainContainer").show();
}

function typologiesUsersIframeLoaded() {

  if($("#typologiesUsersIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
    $("#loadingContainer").hide();
  }

}

function typologiesFilesIframeLoaded() {

}

function categoriesGeneralIframeLoaded() {

  if($("#categoriesGeneralIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
    $("#loadingContainer").hide();
  }

}

function statisticsGeneralIframeLoaded() {

  if($("#statisticsGeneralIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
    $("#loadingContainer").hide();
  }

}

function statisticsFilesIframeLoaded() {

  /*if($("#statisticsFilesIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
    $("#loadingContainer").hide();
  }*/

}

function statisticsUsersIframeLoaded() {

  /*if($("#statisticsUsersIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
    $("#loadingContainer").hide();
  }*/

}

function logIframeLoaded() {

  if($("#logIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
    $("#loadingContainer").hide();
  }

}

function usersGeneralIframeLoaded() {

  if($("#usersGeneralIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
    $("#loadingContainer").hide();
  }

}

function entitiesIframeLoaded() {

  if($("#entitiesIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
    $("#loadingContainer").hide();
  }

}

function loadAreaImage(areaId) {

  /*Aquí no se carga la imagen del área en la administración
  if(applicationId != "vpnet") { //Esto solo está habilitado para DP ya que en la otra versión no se utiliza y carga la aplicación
        $("#areaImage").attr('src', "../../app/downloadAreaImage.cfm?id="+areaId);
  }*/

}

/*
Esto no se usa en la administración
function goToAreaLink() {

  if(areaWithLink == true) {
    window.open("../../app/goToAreaLink.cfm?id="+curAreaId, "_blank");
  }

}*/

function openAreaNewModal(){

  if($.isNumeric(curAreaId))
    loadModal('html_content/area_new.cfm?parent='+curAreaId);
  else
    showAlertModal(window.lang.translate("Debe seleccionar un área en la que crear la nueva"));
}

function openAreaImportModal(){

  if($.isNumeric(curAreaId))
    loadModal('html_content/area_import.cfm?parent='+curAreaId);
  else
    showAlertModal(window.lang.translate("Debe seleccionar un área en la que crear las nuevas áreas"));
}

function openAreaExportModal(){

  if($.isNumeric(curAreaId))
    loadModal('html_content/area_export_structure.cfm?parent='+curAreaId);
  else
    showAlertModal(window.lang.translate("Debe seleccionar un área para exportar"));
}

function openAreaMoveModal(){

  if($.isNumeric(curAreaId))
    loadModal('html_content/area_cut.cfm?area='+curAreaId);
  else
    showAlertModal(window.lang.translate("Debe seleccionar un área para mover"));
}

function openAreaAssociateModal(userId){

  if($.isNumeric(curAreaId))
    loadModal('html_content/area_user_associate.cfm?area='+curAreaId+'&user='+userId);
  else
    showAlertModal(window.lang.translate("Debe seleccionar un área para asociar el usuario"));
}

function openAreasAssociateModal(userId){

  if($.isNumeric(curAreaId))
    loadModal('html_content/areas_user_associate_tree.cfm?user='+userId+'&area='+curAreaId);
  else
    loadModal('html_content/areas_user_associate_tree.cfm?user='+userId);

}

function openAreaAssociateUsersModal(usersIds){

  if($.isNumeric(curAreaId))
    loadModal('html_content/area_users_associate.cfm?area='+curAreaId+'&users='+usersIds);
  else
    //alert("Debe seleccionar un área para asociar los usuarios");
    showAlertModal(window.lang.translate("Debe seleccionar un área para asociar los usuarios"));
}

function openAssociateUsersModal(usersIds, areaId){

  if($.isNumeric(areaId))
    loadModal('html_content/area_users_associate.cfm?area='+areaId+'&users='+usersIds);
  else
    showAlertModal(window.lang.translate("Debe seleccionar un área para asociar los usuarios"));
}

function openAreaAssociateAdministratorModal(userId){

  if($.isNumeric(curAreaId))
    loadModal('html_content/area_administrator_associate.cfm?area='+curAreaId+'&user='+userId);
  else
    showAlertModal(window.lang.translate("Debe seleccionar un área para asociar el administrador"));
}

function openAreaModifyModal(){

  if($.isNumeric(curAreaId))
    loadModal('html_content/area_modify.cfm?area='+curAreaId);
  else
    showAlertModal(window.lang.translate("Debe seleccionar un área para modificar"));
}

function openAreaDeleteModal(){

  if($.isNumeric(curAreaId))
    loadModal('html_content/area_delete.cfm?area='+curAreaId);
  else
    showAlertModal(window.lang.translate("Debe seleccionar un área para eliminar"));

}


function emptyIframes(){

  $("#areaIframe").attr('src', 'iframes/area.cfm');
  $("#userAreaIframe").attr('src', 'about:blank');

}
