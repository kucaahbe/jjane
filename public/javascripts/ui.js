function jjaneRubyCommander (field_name, url, type, win) {

  //alert("Field_Name: " + field_name + "\nURL: " + url + "\nType: " + type + "\nWin: " + win); // debug/testing

  /* If you work with sessions in PHP and your client doesn't accept cookies you might need to carry
     the session name and session ID in the request string (can look like this: "?PHPSESSID=88p0n70s9dsknra96qhuk6etm5").
     These lines of code extract the necessary parameters and add them back to the filebrowser URL again. */

  var cmsURL = '/attached_files';// script URL - use an absolute path!
  if (cmsURL.indexOf("?") < 0) {
    //add the type as the only query parameter
    cmsURL = cmsURL + "?type=" + type;
  }
  else
  {
    //add the type as an additional query parameter
    // (PHP session ID is now included if there is one at all)
    cmsURL = cmsURL + "&type=" + type;
  }

  tinyMCE.activeEditor.windowManager.open( {
file : cmsURL,
title : 'JJane file browser',
width : 800,
height : 600,
resizable : "yes",
inline : "yes",  // This parameter only has an effect if you use the inlinepopups plugin!
close_previous : "no"
}, {
window : win,
input : field_name
} );
return false;
}

function serializeNodeForm(form_id) {tinyMCE.triggerSave();return $(form_id).serialize();}
function previewNode (html_data) {
  previewWindow = window.open('about:blank', 'Node preview');
  previewWindow.document.write(html_data);
}
$(document).ready( function() { $(".jjane_datepicker").datepicker(); } );
