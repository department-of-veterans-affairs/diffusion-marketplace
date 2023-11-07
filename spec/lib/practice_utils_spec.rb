require 'rails_helper'
require_relative '../../lib/modules/practice_utils'

include PracticeUtils

RSpec.describe PracticeUtils do
  before do
    @user = User.create!(
      email: 'mugurama.kensei@va.gov',
      password: 'Password123',
      password_confirmation: 'Password123',
    )
    @practice = Practice.create!(
      name: 'A public practice',
      slug: 'a-public-practice',
      main_display_image: File.new(File.join(Rails.root, '/spec/assets/charmander.png')),
      user: @user
    )
  end

  describe 'practices_json' do
    it 'should convert an array/collection of practice records into an array of JSON objects and add additional custom keys' do
      expect(
        PracticeUtils.practices_json(Practice.all)
      ).to include(
             @practice.id.to_s,
             @practice.name,
             @practice.slug,
             @practice.main_display_image.path, # custom 'image' key
          )
      # Without a current_user
      expect(
        PracticeUtils.practices_json(Practice.all)
      ).to_not include('user_favorited')
      # With a current_user
      expect(
        PracticeUtils.practices_json(Practice.all, @user)
      ).to include('user_favorited')
    end
  end
end