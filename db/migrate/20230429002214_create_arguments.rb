class CreateArguments < ActiveRecord::Migration[7.0]
  def change
    create_table :arguments do |t|
      t.string :title, null: false, default: ""
      t.integer :search_count, default: 0
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
