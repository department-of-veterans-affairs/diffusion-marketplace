require 'support/utils/test_utils'

module TestUtils::Validations
  def expect_valid_record(record)
    expect(record).to be_valid
    expect(record.errors.messages).to be_blank
  end

  def expect_invalid_record(record, record_attribute, validation_message)
    expect(record).to_not be_valid
    expect(record.errors.messages[record_attribute]).to include(validation_message)
  end
end