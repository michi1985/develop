Spree::Taxon.class_eval do
   scope :categories, -> {
     find_by('lower(name)=?', 'categories').descendants}
    scope :categories_with_products, -> {    find_by('lower(name)=?', 'categories').descendants.includes(:products).group(:id).having('count(spree_products.id) > ?',0)}

 end
