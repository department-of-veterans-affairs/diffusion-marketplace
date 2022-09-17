require 'rails_helper'

RSpec.shared_examples 'URL validators' do
  before do
    @validations = validations
  end

  describe 'internal URLs' do
    it 'should be valid if the internal path exists' do
      # invalid URLs
      record.url = '/hello-world'
      @validations.expect_invalid_record(record, :url, 'No route matches "/hello-world"')

      record.url = '/visns/hello-world'
      @validations.expect_invalid_record(record, :url, 'not a valid URL')
      # valid URL
      record.url = '/visns'
      @validations.expect_valid_record(record)
    end
  end

  describe 'external URLs' do
    it 'should be valid if the path matches the external URL regex' do
      # invalid URLs
      record.url = 'wwwww.hello-world.com'
      @validations.expect_invalid_record(record, :url, 'Not a valid external URL')

      record.url = 'http:/test.com/'
      @validations.expect_invalid_record(record, :url, 'Not a valid external URL')
      # valid URL
      record.url = 'https://test.com'
      @validations.expect_valid_record(record)
    end
  end
end