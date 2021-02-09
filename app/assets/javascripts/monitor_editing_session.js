$('document').ready(function(){
    let timerId = setInterval(() => getTimeRemainingForCurrentSession(), 20000);
});

function getTimeRemainingForCurrentSession() {
    debugger
    Rails.ajax({
        type: 'get',
        url: "/session_time_remaining",
        data: jQuery.param({ practice_id: '<%= @practice.id %>'}),
        success: function (data) {
            debugger
            var timeLeft =  data;
            if(timeLeft == 2){
                var response = confirm(data);
                alert(data.toString());
                if (response){
                    //TODO extend session...
                    alert (response);
                }
                else{
                    //TODO end session... and navigate to Metrics...
                    alert('no');
                }
            }
        }
    });
}