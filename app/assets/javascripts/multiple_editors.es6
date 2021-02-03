

    $("#sideNavPracticeNameLinkStartTimer").click(function (e) {
        debugger
        let timerId = setInterval(() => alert('tick'), 4000);
        // after 5 seconds stop
        setTimeout(() => {
            clearInterval(timerId);
            alert('stop');
        }, 20000);
    });


