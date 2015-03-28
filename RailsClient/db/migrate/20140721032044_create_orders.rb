class CreateOrders < ActiveRecord::Migration
  def up
    create_table(:orders, :id => false) do |t|
      t.string :uuid, :limit => 36, :null => false
      t.string :id, :limit => 36, :primary => true, :null => false
      t.boolean :handled, :default => false
    #  t.string :source_id
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #

      t.string :user_id
      t.timestamps
    end
    add_index :orders, :uuid
    add_index :orders, :id
    add_index :orders, :user_id
   # add_index :orders, :source_id
    execute 'ALTER TABLE orders ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :orders
  end
end
