// Use this file to require common dependencies or to setup useful test functions.

// From the blue ridge sample app
function fixture(element) {
  $('<div id="fixtures"/>').append(element).appendTo("body");
}

function teardownFixtures() {
  $("#fixtures").remove();
}
