# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile += %w(
                                                  shared/_utilityFunctions.js
                                                  session_timeout_poller.js
                                                  _visnSelect.js
                                                  _officeSelect.js
                                                  ie.js
                                                  _render_warning_banners.js
                                                  _assign_facility_name.js
                                                  practice_editor_adoptions.js
                                                  practice_page.js
                                                  _practice_editor_utilities.js
                                                  _practice_editor_header.js
                                                  _introduction_image_editor.js
                                                  _overview_image_editor.js
                                                  _usa_file_input.js
                                                  practice_editor_contact.js
                                                  practice_editor_timeline.js
                                                  practice_editor_origin.js
                                                  practice_editor_risk_mitigation.js
                                                  practice_editor_overview.js
                                                  practice_editor_introduction.js
                                                  practice_editor_implementation.js
                                                  practice_editor_utilities.js
                                                  diffusion_history/home_map.js
                                                  diffusion_history/practice_map.js
                                                  diffusion_history/_map_utilities.js
                                                  _practice_card_utilities.js
                                                  metrics_page.js
                                                  visns/visns_index_map.js
                                                  visns/_map_utilities.js
                                                  visns/maps.js
                                                  visns/show.js
                                                  va_facilities/map.js
                                                  va_facilities/facilities_utilities.js
                                                  va_facilities/facility_created_practice_search.js
                                                  va_facilities/facility_adopted_practice_search.js
                                                  _otherCategories.js
                                                  shared/_textarea_counter.js
                                                  _header_utilities.js
                                                  _terms_and_conditions.js
                                                  category_usage.js
                                                  _alert_message_utilities.js
                                                  _page_show.js
                                                  facility_status_definitions_modal.js
                                                  clinical_resource_hubs/crh_show.js
                                                  practices/publication_validation.js
                                                  page/page_map.js
                                                  shared/_signed_resource.js
                                              )

# Precompile additional assets.
# application.es6, application.scss, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.assets.precompile += %w( commontator/* )
Rails.application.config.assets.precompile += %w( practice_editor_introduction.js )
