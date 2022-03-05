const loadingSpinner = ".dm-crh-facilities-loading-spinner";
const tableRows = ".dm-crh-table-rows";
const table = ".crh-facilities-table";
const crhShow = "#crh-show"
const visnNum = parseInt(visnNumber); // set in `app/views/visns/show.html.erb`

function _sendAjaxRequest() {
    $.ajax({
        type: "GET",
        dataType: "json",
        url: `/crh/${visnNum}/created-crh-practices`,
        success: function (data) {
            $(tableRows).append(data);
            $(table).removeClass("display-none");
            $(loadingSpinner).addClass("display-none");
            $(crhShow).data('reload', false);
            //alert(data);
        },
    });
}

function execCrhShowFns() {
    if ($(crhShow).data('reload')) {
        _sendAjaxRequest();
    }
}

document.addEventListener("turbolinks:load", function () {
    execCrhShowFns();
});