// для показа/скрытия превьюшек для nodes
function PreviewNodeShowHide() {
  var p_node = $('preview_node');
  if (p_node.hasClassName('collapsed'))
  {
    p_node.removeClassName('collapsed');
    p_node.addClassName('expanded');
  }
  else
  {
    p_node.removeClassName('expanded');
    p_node.addClassName('collapsed');
  }
}
