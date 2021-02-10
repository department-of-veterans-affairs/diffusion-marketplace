function getTimeRemainingForCurrentSession(practice_id) {
    Rails.ajax({
        type: 'get',
        url: "/session_time_remaining",
        data: jQuery.param({ practice_id: practice_id}),
        success: function (data) {
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
                    //window.location = "/practices/brads-1st-practice/edit/metrics";
                    //TODO save... and navigate to Metrics...
                    //debugger
                    Rails.ajax({
                        type: 'get',
                        url: "/redirect_to_metrics",
                        data: jQuery.param({practice_id: practice_id})
                    });

                    // let save_id = document.getElementById('practice-editor-save-button');
                    // if(save_id){
                    //     save_id.click();
                    // }


                    //window.location = "/practices/brads-1st-practice/edit/metrics";
                    // setTimeout(function(){
                    //     //window.location = "/practices/brads-1st-practice/edit/metrics";
                    //     Rails.ajax({
                    //         type: 'get',
                    //         url: "/redirect_to_metrics",
                    //         data: jQuery.param({practice_id: practice_id})
                    //     });
                    // },5000);
                }
            }
        }
    });
}
