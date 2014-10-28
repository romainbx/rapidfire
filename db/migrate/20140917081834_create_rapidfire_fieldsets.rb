class CreateRapidfireFieldsets < ActiveRecord::Migration
  def change
    create_table :rapidfire_fieldsets do |t|
      t.references :question_group
      t.string  :title
      t.string  :title_cn
      t.text	:description
      t.integer :position
    end
  end
end