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
  -- id assignment
  local id_count = 0
  local new_id = 
    function() 
      id_count = id_count + 1
      return id_count
    end
  -- rest of the object
  local o = {}
  setmetatable(o, transaction)
  o.amt = amount
  o.tag = t
  o.date = os.date("%b %d")
  o.id = new_id()
  return o
end