// from Railscast, http://railscasts.com/episodes/197-nested-model-form-part-2
function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).closest("tr").before(content.replace(regexp, new_id));
}
