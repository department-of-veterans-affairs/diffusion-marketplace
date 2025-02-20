const THIRTY_DAY_LEADER_BOARD = "leader_board_page_views_30_days"
const ALL_TIME_LEADER_BOARD = "leader_board_page_views_all_time"
const ADOPTIONS_BY_PRACTICE_THIRTY_DAYS = "adoptions_by_practice_30"
const ADOPTIONS_BY_PRACTICE_ALL_TIME = "adoptions_by_practice_all_time"

$(document).ready(function(){

    //event handlers for LI(s)
    $("#metrics_duration").change (function(e) {
        var curUrl = window.location.href;
        if(curUrl.includes("?duration")) {
            var pos1 = curUrl.lastIndexOf("?duration");
            curUrl = curUrl.substring(0, pos1);
        }
        let duration = encodeURIComponent($("#metrics_duration").val());
        let newUrl = `${curUrl}?duration=${duration}`;
        window.location.href = newUrl;
    });

    function setButtonStyle(element) {
        $(element).addClass('usa-button usa-button--secondary');
        $(element).removeClass('dm-button--outline-secondary');
    }

    function unsetButtonStyle(element) {
        $(element).removeClass('usa-button usa-button--secondary');
        $(element).addClass('dm-button--outline-secondary');
    }

    function toggleMetricAllTimeVsThirtyTables(el1, el2, class1, class2){
        document.getElementById(el1).classList.remove(class1);
        document.getElementById(el2).classList.remove(class2);
        document.getElementById(el1).classList.add(class2);
        document.getElementById(el2).classList.add(class1);
    }

    $("#toggle_leader_board_view_30").click (function(e) {
        setButtonStyle("#toggle_leader_board_view_30");
        unsetButtonStyle("#toggle_leader_board_view_all_time");
        toggleMetricAllTimeVsThirtyTables(ALL_TIME_LEADER_BOARD, THIRTY_DAY_LEADER_BOARD, "display-inline", "display-none");
    });

    $("#toggle_leader_board_view_all_time").click (function(e) {
        setButtonStyle("#toggle_leader_board_view_all_time");
        unsetButtonStyle("#toggle_leader_board_view_30");
        toggleMetricAllTimeVsThirtyTables(THIRTY_DAY_LEADER_BOARD, ALL_TIME_LEADER_BOARD, "display-inline", "display-none");
    });

    $("#toggle_adoptions_view_30").click (function(e) {
        setButtonStyle("#toggle_adoptions_view_30");
        unsetButtonStyle("#toggle_adoptions_view_all_time");
        toggleMetricAllTimeVsThirtyTables(ADOPTIONS_BY_PRACTICE_ALL_TIME, ADOPTIONS_BY_PRACTICE_THIRTY_DAYS, "display-inline", "display-none");

    });

    $("#toggle_adoptions_view_all_time").click (function(e) {
        setButtonStyle("#toggle_adoptions_view_all_time");
        unsetButtonStyle("#toggle_adoptions_view_30");
        toggleMetricAllTimeVsThirtyTables(ADOPTIONS_BY_PRACTICE_THIRTY_DAYS, ADOPTIONS_BY_PRACTICE_ALL_TIME, "display-inline", "display-none");
    });
});