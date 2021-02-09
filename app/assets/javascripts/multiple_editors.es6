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
                //var response = confirm("Your session is about to expire.  Continue editing?");

                if (confirm("Your session is about to expire.  Continue editing?")){
                    //TODO extend session...
                    Rails.ajax({
                        type: 'get',
                        url: "/extend_editor_session_time",
                        data: jQuery.param({practice_id: practice_id})
                    });
                }
                else{
                    //TODO save... and navigate to Metrics...
                    let save_id = document.getElementById('practice-editor-save-button');
                    if(save_id){
                        save_id.click();
                    }
                    Rails.ajax({
                        type: 'get',
                        url: "/redirect_to_metrics",
                        data: jQuery.param({practice_id: practice_id})
                    });
                }
            }
        }
    });
}
