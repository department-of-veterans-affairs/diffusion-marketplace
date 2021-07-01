const loadingSpinner = ".dm-visn-practices-created-loading-spinner";
const tableRows = ".dm-visns-table-rows";
const table = ".visn-facilities-table";
const visnsShow = "#visns-show"
const visnNum = parseInt(visnNumber); // set in `app/views/visns/show.html.erb`

function _sendAjaxRequest() {
  $.ajax({
    type: "GET",
    dataType: "json",
    url: `/visns/${visnNum}/load-facilities-rows`,
    success: function (data) {
      $(tableRows).append(data.rowsHtml);
      $(table).removeClass("display-none");
      $(loadingSpinner).eq(2).addClass("display-none");
      $(visnsShow).data('reload', false);
    },
  });
}

function execVisnsShowFns() {
  if ($(visnsShow).data('reload')) {
    _sendAjaxRequest();
  }
}

document.addEventListener("turbolinks:load", function () {
  execVisnsShowFns();
});
