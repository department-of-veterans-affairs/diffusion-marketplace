# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile += %w(
                                                  _visnSelect.js
                                                  _officeSelect.js ie.js
                                                  _render_warning_banners.js
                                                  _assign_facility_name.js
                                                  _facilitySelect.js
                                                  practice_editor_adoptions.js
                                                  practice_page.js
                                                  practice_editor_checklist.js
                                                  _practice_editor_utilities.js
                                                  _cropper.js practice_editor_impact.js
                                                  practice_editor_documentation.js
                                                  practice_editor_contact.js
                                                  practice_editor_timeline.js
                                                  practice_editor_origin.js
                                                  practice_editor_risk_mitigation.js
                                                  practice_editor_complexity.js
                                                  practice_editor_overview.js
                                                  practice_editor_introduction.js
                                                  practice_editor_utilities.js
                                                  diffusion_history/home_map.js
                                                  diffusion_history/practice_map.js
                                                  diffusion_history/_map_utilities.js
                                              )

# Precompile additional assets.
# application.es6, application.scss, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.assets.precompile += %w( commontator/* )
Rails.application.config.assets.precompile += %w( practice_editor_introduction.js )
