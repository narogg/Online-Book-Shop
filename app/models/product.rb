class Product < ActiveRecord::Base

  default_scope :order => 'created_at desc'
  has_many :line_items
  
  
  # A hook method is a method that
  # Rails calls automatically at a given point in an object’s life. In this case, the
  # method will be called before Rails attempts to destroy a row in the database.
  # If the hook method returns false, the row will not be destroyed
  before_destroy :ensure_not_referenced_by_any_line_item
  
  # ensure that there are no line items referencing this product, when deleting product
  def ensure_not_referenced_by_any_line_item  
    if line_items.count.zero?
     return true
    else
     errors[:base] << "Line Items present!"
    return false
    end
  end
  
  
  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true, length: { in: 6..50 ,
					message: "%{value} nije dulji od 6 a manji od 20, nista od tog borac!"}

  validates :image_url, :format => {:with => %r{\.(gif|jpg|png)$}i,
	:message => 'must be a URL for GIF, JPG or PNG image.',:multiline => true}
end
