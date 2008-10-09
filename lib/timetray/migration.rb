class CreateTimeTrayDB < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name, :null => false
      t.timestamps
    end

    create_table :tasks do |t|
      t.string  :name,        :null => false
      t.integer :project_id,  :null => false
      t.timestamps
    end

    create_table :logs do |t|
      t.integer  :task_id,    :null => false
      t.datetime :started_at, :null => false
      t.datetime :stopped_at
    end
  end
end
