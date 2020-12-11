(($) => {
    const $document = $(document);



    $document.on('turbolinks:load');
})(window.jQuery);

function hideSecondaryNavItems(){
    debugger
    document.getElementById('peSideNavAbout').style.display = 'none';
    document.getElementById('peSideNavContact').style.display = 'none';
    document.getElementById('peSideNavImplementation').style.display = 'none';
    document.getElementById('peSideNavOverview').style.display = 'none';
    document.getElementById('peSideNavAdoptions').style.display = 'none';
    document.getElementById('peSideNavIntroduction').style.display = 'none';
}

$(document).ready(function(){
    //event handlers for LIs
    $("#peSideNavMetrics").click(function(e){
        e.stopPropagation();
        hideSecondaryNavItems();
    });

    $("#peSideNavEditingGuide").click(function(e){
        e.stopPropagation();
        hideSecondaryNavItems();
    });

    $("#metrics_duration").change (function(e) {
        //alert(window.location.href);
        var curUrl = window.location.href;
        if(curUrl.includes('@duration')) {
            var pos1 = curUrl.lastIndexOf("&duration");
            curUrl = curUrl.substring(0, pos1);
        }
        //alert(curUrl);
        let duration = $( "#metrics_duration" ).val();
        let newUrl = curUrl + "&duration=" + duration;
        window.location.href = newUrl;
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









function showHideSideNavElements(){
    alert('hello');
    let nav_item = document.getElementById('pe_side_nav_about');
    if(nav_item.style.display == 'none')
    {
        nav_item.style.display = 'inline';
    }
}
