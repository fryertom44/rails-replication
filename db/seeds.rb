# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
connection = ActiveRecord::Base.connection()
connection.execute <<~SQL
  TRUNCATE TABLE transactions;
  TRUNCATE TABLE users;
  INSERT INTO users (
    email, created_at, updated_at
  )
  SELECT
    ('user' || i || '@example.com'), now(), now()
  FROM generate_series(1, 1000) s(i);
SQL

User.find_each do |u|
  print "Creating 100K transactions for #{u.email}"
  connection.execute <<~SQL
    INSERT INTO transactions (
      user_id, original_date, amount_pennies, merchant_name, created_at, updated_at
    )
    SELECT
      #{u.id},
      date(
        (current_date - '2 years'::interval) +
        (trunc(random() * 365) * '1 day'::interval) +
        (trunc(random() * 14) * '1 year'::interval)
      ),
      floor(random() * 10000 + 1)::int,
      ('{Tesco,Amazon,Itsu,McDonalds,Nandos,KFC,Waitrose,Asda,Lidl,Sainsburys}'::text[])[ceil(random()*10)],
      now(),
      now()
    FROM generate_series(1, 100000) s(i);
  SQL
end
