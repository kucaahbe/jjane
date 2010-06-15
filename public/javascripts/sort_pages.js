function get_class_by_regexp(e,reg_exp)
{
  result = null;
  classList = e.attr('class').split(' ');
  re = new RegExp(reg_exp);
  $.each(classList, function(index, klass) { if ( re.exec(klass)!=null ) {result=klass;return false;} });
  return result;
}
function id(e){return parseInt(e.attr('id').replace(/page_/,''))}
function level(e){return parseInt(get_class_by_regexp(e,/level_\d+/).replace(/level_/,''))}
function set_new_level(e,level_value)
{
  old_class = get_class_by_regexp(e,/level_\d+/);
  e.removeClass(old_class);
  e.addClass('level_'+level_value);
}
function top_neighbor_of(e){o=e.prev();if (o.length){return o;}else{return null};}
function bottom_neighbor_of(e){o=e.next();if (o.length){return o;}else{return null};}
