$('document').ready(function(){
    let timerId = setTimeout(() => getTimeRemainingForCurrentSession(), 780000);
    // after 5 seconds stop
    // setTimeout(() => {
    //     clearInterval(timerId);
    //     alert('stop');
    // }, 120000);
    const $document = $(document);

});

function getTimeRemainingForCurrentSession() {
    debugger
    Rails.ajax({
        type: 'post',
        url: "/session_time_remaining",
        data: {
            // product_id: product_id,
            // user_id: user_id
        },
        success: function (data) {
            //debugger
            alert(data);
        }
    });
}





// (($) => {
//     function startSessionMonitor() {
//         debugger
//         let timerId = setInterval(() => alert('session done?'), 5000);
//         // after 5 seconds stop
//         setTimeout(() => {
//             clearInterval(timerId);
//             alert('stop');
//         }, 20000);
//         const $document = $(document);
//     }
//
//     function alert_me(msg){
//         alert(msg);
//     }
//     $document.on('turbolinks:load', startSessionMonitor);
// })(window.jQuery);







$("#sideNavPracticeNameLinkStartTimer").click(function (e) {
        debugger
        let timerId = setInterval(() => alert('tick'), 4000);
        // after 5 seconds stop
        setTimeout(() => {
            clearInterval(timerId);
            alert('stop');
        }, 20000);
    });


