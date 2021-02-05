(($) => {
    function startSessionMonitor() {
        let timerId = setInterval(() => alert_me('session done?'), 5000);
        // after 5 seconds stop
        setTimeout(() => {
            clearInterval(timerId);
            alert('stop');
        }, 20000);
        const $document = $(document);
    }

    function alert_me(msg){
        alert(msg);
    }
    $document.on('turbolinks:load', startSessionMonitor);
})(window.jQuery);







$("#sideNavPracticeNameLinkStartTimer").click(function (e) {
        debugger
        let timerId = setInterval(() => alert('tick'), 4000);
        // after 5 seconds stop
        setTimeout(() => {
            clearInterval(timerId);
            alert('stop');
        }, 20000);
    });


