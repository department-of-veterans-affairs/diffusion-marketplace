$(document).ready(function(){
    //event handlers for LI(s)
    $("#metrics_duration").change (function(e) {
        var curUrl = window.location.href;
        if(curUrl.includes("?duration")) {
            var pos1 = curUrl.lastIndexOf("?duration");
            curUrl = curUrl.substring(0, pos1);
        }
        let duration = $( "#metrics_duration" ).val();
        let newUrl = curUrl + "?duration=" + duration;
        window.location.href = newUrl;
    });

    $("#toggle_leader_board_view_30").click (function(e) {
        document.getElementById("leader_board_page_views_all_time").style.display = 'none';
        document.getElementById("leader_board_page_views_30_days").style.display = 'inline';
    });

    $("#toggle_leader_board_view_all_time").click (function(e) {
        document.getElementById("leader_board_page_views_30_days").style.display = 'none';
        document.getElementById("leader_board_page_views_all_time").style.display = 'inline';
    });

    $("#toggle_adoptions_view_30").click (function(e) {
        document.getElementById("adoptions_by_practice_all_time").style.display = 'none';
        document.getElementById("adoptions_by_practice_30").style.display = 'inline';
    });

    $("#toggle_adoptions_view_all_time").click (function(e) {
        document.getElementById("adoptions_by_practice_30").style.display = 'none';
        document.getElementById("adoptions_by_practice_all_time").style.display = 'inline';
    });



    $("#peSideNavPracticeName").click(function(e){
        e.stopPropagation();
        let curAboutState = document.getElementById('peSideNavAbout');

        let navItem = document.getElementById('peSideNavAbout');
        navItem.style.display = 'inline';

        navItem = document.getElementById('peSideNavIntroduction');
        navItem.style.display = 'inline';

        navItem = document.getElementById('peSideNavOverview');
        navItem.style.display = 'inline';

        navItem = document.getElementById('peSideNavContact');
        navItem.style.display = 'inline';

        navItem = document.getElementById('peSideNavImplementation');
        navItem.style.display = 'inline';

        navItem = document.getElementById('peSideNavOverview');
        navItem.style.display = 'inline';

        navItem = document.getElementById('peSideNavAdoptions');
        navItem.style.display = 'inline';
    });
});