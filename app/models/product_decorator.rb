Spree::Product.class_eval do
   scope :with_taxons_name, -> (category) {
     includes(:taxons).where("upper(spree_taxons.name) = ?", category).references(:taxons)}
end
