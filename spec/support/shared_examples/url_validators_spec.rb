require 'rails_helper'
require 'support/test_utils/attribute_validators'

include TestUtils::AttributeValidators

RSpec.shared_examples 'URL validators' do
  describe 'internal URLs' do
    it 'should be valid if the internal path exists' do
      # invalid URLs
      record.url = '/hello-world'
      expect_invalid_record(record, :url, 'No route matches "/hello-world"')

      record.url = '/visns/hello-world'
      expect_invalid_record(record, :url, 'not a valid URL')
      # valid URL
      record.url = '/visns'
      expect_valid_record(record)
    end
  end

  describe 'external URLs' do
    it 'should be valid if the path matches the external URL regex' do
      # invalid URLs
      record.url = 'wwwww.hello-world.com'
      expect_invalid_record(record, :url, 'Not a valid external URL')

      record.url = 'http:/test.com/'
      expect_invalid_record(record, :url, 'Not a valid external URL')
      # valid URL
      record.url = 'https://test.com'
      expect_valid_record(record)
    end
  end
end