(($) => {
    const $document = $(document);

    function feedbackSurveyModal() {
        // Get the modal
        const modal = document.getElementById("feedbackModal");

        // Get the button that opens the modal
        const $feedbackModalTriggers = $(".feedback-survey-popup");

        // Get the <span> element that closes the modal
        const $span = $(".close");
        const $lastEl = $(".last_el");
        const $firstEl = $(".first_el");

        // When the user clicks the button, open the modal
        $feedbackModalTriggers.click(function(e) {
            e.preventDefault();
            modal.style.display = "block";
            $span.focus();
        });

        // When the user clicks on <span> (x), close the modal
        $span.click(function() {
            modal.style.display = "none";
        });

        $span.on('keypress',function(e) {
          if(e.which == 13) {
            modal.style.display = "none";
          }
        });

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }

        // When the user shift tabs to the first element in the modal, close it

        $firstEl.on('focus', function(e){
          modal.style.display = "none";
        })

        // When the user focuses on the last element in the modal, close it
        $lastEl.on('focus', function(e){
          modal.style.display = "none";
        });
    }

    $document.on('turbolinks:load', feedbackSurveyModal);
})(window.jQuery);