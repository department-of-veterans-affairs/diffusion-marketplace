function getTimeRemainingForCurrentSession(practice_id) {
    debugger
    Rails.ajax({
        type: 'get',
        url: "/session_time_remaining",
        data: jQuery.param({ practice_id: practice_id}),
        success: function (data) {
            debugger
            var timeLeft =  data;
            if(timeLeft == 2){
                var response = confirm("Your session is about to expire.  Continue editing?");

                if (response){
                    //TODO extend session...
                    Rails.ajax({
                        type: 'get',
                        url: "/extend_editor_session_time",
                        data: jQuery.param({practice_id: practice_id}),
                    });
                    //alert (response);
                }
                else{
                    //TODO end session... and navigate to Metrics...
                    alert('no');
                }
            }
        }
    });
}
