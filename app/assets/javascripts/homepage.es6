document.addEventListener('DOMContentLoaded', function() {
  var customMenuButton = document.getElementById('customMenuButton');
  var originalMenuButton = document.getElementById('originalMenuButton');

  if (customMenuButton && originalMenuButton) {
    customMenuButton.addEventListener('click', function() {
      originalMenuButton.click();
    });
  }
});
