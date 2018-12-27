// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require uswds/uswds
//= require_tree .


document.addEventListener('turbolinks:load', function() {

  document.getElementById('risks-mitigations-toggle').onclick = function() {
    var el = document.querySelector('#risks-mitigations-toggle h3');
    el.classList.add('section-selected');
    el = document.querySelector('#cost-difficulty-toggle h3');
    el.classList.remove('section-selected');

    el = document.getElementById('risks-mitigations');
    el.style.display = 'block';
    el = document.getElementById('cost-difficulty');
    el.style.display = 'none';
  }

  document.getElementById('cost-difficulty-toggle').onclick = function() {
    var el = document.querySelector('#cost-difficulty-toggle h3');
    el.classList.add('section-selected');
    el = document.querySelector('#risks-mitigations-toggle h3');
    el.classList.remove('section-selected');

    el = document.getElementById('cost-difficulty');
    el.style.display = 'block';
    el = document.getElementById('risks-mitigations');
    el.style.display = 'none';
  }

}, false);
