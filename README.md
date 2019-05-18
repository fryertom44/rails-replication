# rails-replication

# not sure if 'replication' is needed, as this relates to streaming replication, not logical
create role techlunch with createdb login replication password 'password1';

To setup databases:
> bin/rails g migration CreateUsers
> bin/rails g migration CreateTransactions
> bin/rails g migration CreateTransactions --db=slave
> bin/rails db:migrate
> bin/rails db:migrate:slave

To setup replication:
 - Enable logical replication
 > sudo vi /usr/local/var/postgres/postgresql.conf
    Change replica to logical
    #wal_level = logical                    # minimal, replica, or logical
 - Add address of slave (if not on localhost)
 > sudo vi /usr/local/var/postgres/pg_hba.conf
 - Also open firewall port 5432 if slave is on different ip to master
 - Save and restart
 
 Then setup pub/sub replication
  Publication:
  > psql techlunch_master_development
  > CREATE PUBLICATION techlunch_pub FOR TABLE users, transactions;
  Subscription:
  > psql techlunch_slave_development
  > CREATE SUBSCRIPTION techlunch_sub CONNECTION 'dbname=techlunch_master_development host=localhost user=techlunch' PUBLICATION techlunch_pub;
  This takes a while (> 2hrs) because it needs to replicate the whole db first.

Limitations:
 - Cannot do joins across databases. If required, these join tables must also be prevent in the slave database
