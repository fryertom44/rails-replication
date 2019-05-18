class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.datetime :original_date
      t.integer :amount_pennies
      t.string :amount_currency, default: 'GBP'
      t.string :merchant_name, index: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
