class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end

    add_column :beers, :style_id, :integer

    Beer.uniq.pluck(:style).each do |style|
      Style.create(name:style, description:"")
    end

    rename_column :beers, :style, :old_style

    Beer.all.each do |beer|
      beer.style = Style.find_by(name:beer.old_style)
      beer.save!
    end

    remove_column :beers, :old_style, :string
  end
end
