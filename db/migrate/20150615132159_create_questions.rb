class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, limit: 250
      t.text   :body , limit: 10000

      t.timestamps null: false
    end
  end
end
