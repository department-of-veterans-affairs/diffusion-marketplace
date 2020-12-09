function showHideSideNavElements(){
    alert('hello');
    let nav_item = document.getElementById('pe_side_nav_about');
    if(nav_item.style.display == 'none')
    {
        nav_item.style.display = 'inline';
    }
}

$(document).ready(function(){

    $("#peSideNavPracticeName").click(function(e){
        e.stopPropagation();
        alert('practiceName');
        debugger
        let curAboutState = document.getElementById('peSideNavAbout');
        //alert(curAboutState.style.display);

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

    $("#peSideNavIntroduction").click(function(e){
        e.stopPropagation();
        alert('introduction');
        debugger
        let navItem = document.getElementById('peSideNavAbout');

        if(navItem.style.display == 'none'){
            navItem.style.display = 'inline';
        }
    });


    $("#peSideNavAdoptions").click(function(e){
        e.stopPropagation();
        alert('adoptions');
        debugger
        let navItem = document.getElementById('peSideNavAbout');

        if(navItem.style.display == 'none'){
            navItem.style.display = 'inline';
        }
    });

    $("#peSideNavOverview").click(function(e){
        e.stopPropagation();
        alert('overview');
        debugger
        let navItem = document.getElementById('peSideNavOverview');

        if(navItem.style.display == 'none'){
            navItem.style.display = 'inline';
        }
    });
    $("#peSideNavPImplementation").click(function(e){
        e.stopPropagation();
        alert('implementations');
        debugger
        let navItem = document.getElementById('peSideNavImplementation');

        if(navItem.style.display == 'none'){
            navItem.style.display = 'inline';
        }
    });

    $("#peSideNavContact").click(function(e){
        e.stopPropagation();
        alert('contact');
        debugger
        let navItem = document.getElementById('peSideNavContact');

        if(navItem.style.display == 'none'){
            navItem.style.display = 'inline';
        }
    });
    $("#peSideNavAbout").click(function(e){
        e.stopPropagation();
        alert('about');
        debugger
        let navItem = document.getElementById('peSideNavAbout');

        if(navItem.style.display == 'none'){
            navItem.style.display = 'inline';
        }
    });

    $("#peSideNavEditingGuide").click(function(e){
        //e.stopPropagation();
        alert('edit guide');
        debugger
        let navItem = document.getElementById('peSideNavAbout');

        if(navItem.style.display == 'inline' || navItem.style.display == ''){
            navItem.style.display = 'none';
        }
    });
});