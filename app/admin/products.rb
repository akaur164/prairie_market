ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category_id, :image

  index do
    selectable_column
    id_column

    column :image do |product|
      if product.image.attached?
        image_tag product.image, width: 80
      else
        "No Image"
      end
    end

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
      f.input :image, as: :file

      if f.object.image.attached?
        li do
          image_tag f.object.image, width: 150
        end
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :price
      row :category
      row :created_at
      row :updated_at

      row :image do |product|
        if product.image.attached?
          image_tag product.image, width: 300
        else
          "No Image Uploaded"
        end
      end
    end
  end
end
