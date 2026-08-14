ActiveAdmin.register Province do
  permit_params :name,
                :code,
                :gst_rate,
                :pst_rate,
                :hst_rate

  index do
    selectable_column
    id_column

    column :name
    column :code
    column :gst_rate
    column :pst_rate
    column :hst_rate

    actions
  end

  filter :name
  filter :code

  show do
    attributes_table do
      row :id
      row :name
      row :code
      row :gst_rate
      row :pst_rate
      row :hst_rate
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Province Tax Rates" do
      f.input :name
      f.input :code
      f.input :gst_rate
      f.input :pst_rate
      f.input :hst_rate
    end

    f.actions
  end
end