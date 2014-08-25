class Product < ActiveRecord::Base

  default_scope :order => 'title'

  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true, length: { in: 6..50 ,
					message: "%{value} nije dulji od 6 a manji od 20, nista od tog borac!"}

  validates :image_url, :format => {:with => %r{\.(gif|jpg|png)$}i,
	:message => 'must be a URL for GIF, JPG or PNG image.',:multiline => true}
end
