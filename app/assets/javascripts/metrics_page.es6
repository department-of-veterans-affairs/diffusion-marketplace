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



        if(navItem.style.display == 'none'){

        }
    });

    // $("#peSideNavIntroduction").click(function(e){
    //     e.stopPropagation();
    //     alert('introduction');
    //     debugger
    //     curPage = 'introduction';
    //     let navItem = document.getElementById('peSideNavIntroduction');
    //
    //     if(navItem.style.display == 'none'){
    //         navItem.style.display = 'inline';
    //     }
    // });
    //
    //
    // $("#peSideNavAdoptions").click(function(e){
    //     e.stopPropagation();
    //     alert('adoptions');
    //     debugger
    //     let navItem = document.getElementById('peSideNavAdoptions');
    //
    //     if(navItem.style.display == 'none'){
    //         navItem.style.display = 'inline';
    //     }
    // });
    //
    // $("#peSideNavOverview").click(function(e){
    //     e.stopPropagation();
    //     alert('overview');
    //     debugger
    //     let navItem = document.getElementById('peSideNavOverview');
    //
    //     if(navItem.style.display == 'none'){
    //         navItem.style.display = 'inline';
    //     }
    // });
    // $("#peSideNavImplementation").click(function(e){
    //     e.stopPropagation();
    //     alert('implementations');
    //     debugger
    //     let navItem = document.getElementById('peSideNavImplementation');
    //
    //     if(navItem.style.display == 'none'){
    //         navItem.style.display = 'inline';
    //     }
    // });
    //
    // $("#peSideNavContact").click(function(e){
    //     e.stopPropagation();
    //     alert('contact');
    //     debugger
    //     let navItem = document.getElementById('peSideNavContact');
    //
    //     if(navItem.style.display == 'none'){
    //         navItem.style.display = 'inline';
    //     }
    // });
    // $("#peSideNavAbout").click(function(e){
    //     e.stopPropagation();
    //     alert('about');
    //     debugger
    //     let navItem = document.getElementById('peSideNavAbout');
    //
    //     if(navItem.style.display == 'none'){
    //         navItem.style.display = 'inline';
    //     }
    // });
});

// document.addEventListener('DOMContentLoaded', function(e) {
//     debugger
//     alert(e.target.id)
//     if(curPage.length > 0){
//         alert('in here');
//     }
// }, false);








function showHideSideNavElements(){
    alert('hello');
    let nav_item = document.getElementById('pe_side_nav_about');
    if(nav_item.style.display == 'none')
    {
        nav_item.style.display = 'inline';
    }
}
