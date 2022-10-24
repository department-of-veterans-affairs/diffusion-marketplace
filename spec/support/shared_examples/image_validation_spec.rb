require 'rails_helper'
require 'support/test_utils/attribute_validators'

include TestUtils::AttributeValidators

def invalid_image_path
  "#{Rails.root}/spec/assets/SpongeBob.txt"
end

def valid_image_path
  "#{Rails.root}/spec/assets/charmander.png"
end

RSpec.shared_examples 'Image presence validation' do
  it "should be valid if it is present" do
    # Invalid image
    record.image = nil
    expect_invalid_record(record, image_attribute, "can't be blank")
    # Valid image
    record.image = File.new(valid_image_path)
    expect_valid_record(record)
  end
end

RSpec.shared_examples 'Image content type validation' do
  it "should be valid if it has a content type of 'jpg', 'jpeg', or 'png'" do
    # Invalid image
    record.image = File.new(invalid_image_path)
    expect_invalid_record(
      record,
      image_attribute,
      "must be one of the following types: jpg, jpeg, or png"
    )
    # Valid image
    record.image = File.new(valid_image_path)
    expect_valid_record(record)
  end
end
