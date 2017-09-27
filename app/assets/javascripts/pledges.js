/* Helper functions */
// opens a new tab (or window) with the given URL
function openInNewTab(url) {
    var win = window.open(url, '_blank');
    win.focus();
}


/* Event-handling JS (designed to work w/ Turbolinks) */
var ready;
ready = function() {
    // Pledging buttons will open a new tab to the Amazon item
    $('input[data-amazon-url]').click(function(e) {
        openInNewTab($(this).data('amazon-url'));
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);
