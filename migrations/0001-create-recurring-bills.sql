create table if not exists recurring_bills(
  id bigserial primary key,
  name text not null,
  amount_in_pennies integer not null,
  pay_period integer not null);
