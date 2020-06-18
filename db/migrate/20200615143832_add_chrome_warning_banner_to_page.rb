class AddChromeWarningBannerToPage < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :has_chrome_warning_banner, :boolean, default: false
  end
end
