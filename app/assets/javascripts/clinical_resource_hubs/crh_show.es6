const loadingSpinner = ".dm-visn-facilities-loading-spinner";
const tableRows = ".dm-visns-table-rows";
const table = ".visn-facilities-table";
const visnsShow = "#visns-show"
const visnNum = parseInt(visn_number); // set in `app/views/visns/show.html.erb`

function _sendAjaxRequest() {
    $.ajax({
        type: "GET",
        dataType: "json",
        url: `/crh/${visnNum}/load-facilities-rows`,
        success: function (data) {
            $(tableRows).append(data.rowsHtml);
            $(table).removeClass("display-none");
            $(loadingSpinner).addClass("display-none");
            $(visnsShow).data('reload', false);
        },
    });
}

function execCrhShowFns() {
    if ($(visnsShow).data('reload')) {
        _sendAjaxRequest();
    }
}

document.addEventListener("turbolinks:load", function () {
    execCrhShowFns();
});