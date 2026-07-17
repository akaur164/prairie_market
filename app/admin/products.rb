ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category_id

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :category
    column :created_at
    actions
  end

  filter :name
  filter :description
  filter :price
  filter :category
  filter :created_at

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :price
      f.input :category
    end

    f.actions
  end
end