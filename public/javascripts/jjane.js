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
