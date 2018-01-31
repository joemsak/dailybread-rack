module DB
  QUERIES = {
    all_recurring_bills: Query.new(sql: %(
      select * from recurring_bills;
    )),

    create_recurring_bill: Query.new(sql: %(
      insert into recurring_bills (name, amount_in_pennies, pay_period)
      values($1, $2, $3);
    )),

    last_recurring_bill: Query.new(sql: %(
      select * from recurring_bills order by id desc limit 1;
    ), returns: :one)
  }
end
