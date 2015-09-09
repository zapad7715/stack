class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :user_id
      t.integer :votable_id
      t.string :votable_type
      t.integer :value
      t.timestamps null: false
      t.index([:votable_id, :votable_type], unique: true)
    end
  end
end
