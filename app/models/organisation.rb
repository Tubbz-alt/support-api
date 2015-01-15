require 'content_api/enhanced_content_api'

class Organisation < ActiveRecord::Base
  has_and_belongs_to_many :content_items

  validates :slug, presence: true
  validates :web_url, presence: true
  validates :title, presence: true

  def self.for_path(path)
    orgs_data = SupportApi::enhanced_content_api.organisations_for(path) || []
    orgs_data.map {|org_info| Organisation.where(org_info).first_or_create! }
  end
end
