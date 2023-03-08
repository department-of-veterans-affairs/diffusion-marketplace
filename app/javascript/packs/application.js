/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Uncomment to copy all static images under ./images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('./images', true)
// const imagePath = (name) => images(name, true)
var Turbolinks = require("turbolinks")
Turbolinks.start()
import 'arrive/minified/arrive.min';
import '../../assets/javascripts/session_timeout_poller';
import '../../assets/javascripts/application';
import './shared/_utilityFunctions';
import './terms_and_conditions';
import './_header_utilities';
import './_alert_message_utilities';
import './_ahoy_event_tracking.js.erb';
import '../../../node_modules/@uswds/uswds/dist/js/uswds-init.min';
import '../../../node_modules/@uswds/uswds/dist/js/uswds.min';