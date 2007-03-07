class Exhibit < ActiveRecord::Base
  belongs_to :user
  belongs_to :license
  belongs_to :exhibit_type
  has_many :exhibited_sections, :order => "position"
  
  def template
    self.exhibit_type.template
  end
  
  def uris
    self.exhibited_sections.collect { |es| es.uris }.flatten
  end
  
end
