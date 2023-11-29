FactoryBot.define do
  factory :page_two_to_one_image_component do
    title { "Sample Title" }
    url { "https://example.com" }
    url_link_text { "Example Link" }
    text { "Sample Text" }
    text_alignment { ["Left", "Right"].sample }
    image_file_name { "charmander.png" }
    image_alt_text { "Sample Image Alt Text" }
    flipped_ratio { [true, false].sample }

    image { File.new(Rails.root.join('spec', 'assets', 'charmander.png')) }
  end
end