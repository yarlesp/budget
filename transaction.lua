-- transaction object

transaction = {}

-- tag for the transaction (user-defined)
-- amount of the transaction
-- whether or not the transaction is income
transaction = {
  tag = "",
  amt = 0, 
  income = false,
  id = 0
}

transaction.__index = transaction

function transaction.new(t, amount, date)
  local o = {}
  setmetatable(o, transaction)
  o.amt = amount
  o.tag = t
  o.date = os.date("%b %d")
  return o
end