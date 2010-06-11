require("spec_helper.js");
require("../../public/javascripts/application.js");

Screw.Unit(function() {
    after(function() {
        teardownFixtures()
    });

    describe("Adding degree fields (see views/personnel/edit)", function() {
        before(function() {
            fixture($('<form id="degrees"/>')
                    .append($('<table/>')
                    .append($('<tr/>')
                    .append('<a href="" id="the-link">Add degree</a>'))));
        });

        it("adds content before the link", function() {
            add_fields($("#the-link"), "degree", '<span class="new-content" id="new_degree">the new content</span>');
            expect($("span.new-content").text()).to(equal, "the new content");
        });

        it("changes the id to a very long number", function() {
            add_fields($("#the-link"), "degree", '<span class="new-content" id="new_degree">the new content</span>');
            expect($("span.new-content").attr("id")).to(match, /\d+/);
        });
    });
});

