class CreateShiftjobs < ActiveRecord::Migration
  def change
    create_table :shiftjobs do |t|
      t.integer :job_id
      t.integer :shift_id

      t.timestamps
    end
  end
end
