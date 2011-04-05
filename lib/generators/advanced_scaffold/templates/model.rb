class <%= class_name %> < ActiveRecord::Base
  attr_accessible <%= model_attributes.map { |a| ":#{a.name}"}.join(", ") %>

  def self.per_page
    15
  end

  def self.pag(page="", conditions="", per_page=nil)
    paginate  :per_page =>  per_page.present? ? per_page  : self.per_page,
              :page => !page.blank? ? page:nil,
              :conditions =>  conditions
  end
  def self.search(search)
    if search.present?
      where('<%= model_attributes.map { |a| "#{a.name} LIKE :search" if %w[string text].include?(a.type.to_s) }.compact.join(" or ") %>', :search => search)
    else
      scoped
    end
  end
end
