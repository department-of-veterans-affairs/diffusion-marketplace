(($) => {
    const $document = $(document);

    function facilityComplexityDefinitions() {
        // Get the modal
        var modal = document.getElementById("facility_complexity_definitions");

// Get the button that opens the modal
        var link = document.getElementById("facility-complexity-modal");

// Get the <span> element that closes the modal
        var span = document.getElementsByClassName("close")[0];

// When the user clicks on the button, open the modal
        link.onclick = function() {
            modal.style.display = "block";
        }

// When the user clicks on <span> (x), close the modal
        span.onclick = function() {
            modal.style.display = "none";
        }

// When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    }

    $document.on('turbolinks:load', facilityComplexityDefinitions);
})(window.jQuery);