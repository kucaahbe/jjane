// для показа/скрытия превьюшек для nodes
function PreviewNodeShowHide() {
  var p_node = $('preview_node');
  var text_areas = $$('#preview_node textarea')
  if (p_node.hasClassName('collapsed'))
  {
    p_node.removeClassName('collapsed');
    p_node.addClassName('expanded');
    text_areas.each(function(ta) { ta.show(); });
  }
  else
  {
    p_node.removeClassName('expanded');
    p_node.addClassName('collapsed');
    text_areas.each(function(ta) { ta.hide(); });
  }
}


/*-----------------------------------------------------------
    Toggles element's display value
    Input: any number of element id's
    Output: none 
    ---------------------------------------------------------*/
function toggleDisp() {
    for (var i=0;i<arguments.length;i++){
        var d = $(arguments[i]);
        if (d.style.display == 'none')
            d.style.display = 'block';
        else
            d.style.display = 'none';
    }
}
/*-----------------------------------------------------------
    Toggles tabs - Closes any open tabs, and then opens current tab
    Input:     1.The number of the current tab
                    2.The number of tabs
                    3.(optional)The number of the tab to leave open
                    4.(optional)Pass in true or false whether or not to animate the open/close of the tabs
    Output: none 
    ---------------------------------------------------------*/
function toggleTab(num,numelems,opennum,animate) {
    if ($('tabContent'+num).style.display == 'none'){
        for (var i=1;i<=numelems;i++){
            if ((opennum == null) || (opennum != i)){
                var temph = 'tabHeader'+i;
                var h = $(temph);
                if (!h){
                    var h = $('tabHeaderActive');
                    h.id = temph;
                }
                var tempc = 'tabContent'+i;
                var c = $(tempc);
                if(c.style.display != 'none'){
                    if (animate || typeof animate == 'undefined')
                        Effect.toggle(tempc,'blind',{duration:0.5, queue:{scope:'menus', limit: 3}});
                    else
                        toggleDisp(tempc);
                }
            }
        }
        var h = $('tabHeader'+num);
        if (h)
            h.id = 'tabHeaderActive';
        h.blur();
        var c = $('tabContent'+num);
        c.style.marginTop = '2px';
        if (animate || typeof animate == 'undefined'){
            Effect.toggle('tabContent'+num,'blind',{duration:0.5, queue:{scope:'menus', position:'end', limit: 3}});
        }else{
            toggleDisp('tabContent'+num);
        }
    }
}


function jjaneRubyCommander (field_name, url, type, win) {

  alert("Field_Name: " + field_name + "\nURL: " + url + "\nType: " + type + "\nWin: " + win); // debug/testing

  /* If you work with sessions in PHP and your client doesn't accept cookies you might need to carry
     the session name and session ID in the request string (can look like this: "?PHPSESSID=88p0n70s9dsknra96qhuk6etm5").
     These lines of code extract the necessary parameters and add them back to the filebrowser URL again. */

  var cmsURL = '/attached_files';//window.location.toString();    // script URL - use an absolute path!
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
      width : 800,  // Your dimensions may differ - toy around with them!
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
