-- contains budget logic

budget = {}

budget = {
  name = "",
  transactions = {},    -- list of all transactions in budget. subdivided by months
  transaction_tags = { "new", "savings", "income" },            -- list of tags for transactions
  fixed_expenses = {},  -- list of all fixed expenses. in the form of {name = "x", amt = "0"} etc
  savings = 0,
  income = {            -- income. average of last twelve available months
    monthly_avg = 0,
    history = {},
  },
  expenses = {          -- expenses, average of last twelve available months
    monthly_avg = 0,
    history = {},
  },
  limits = {              -- limits per month for each transaction tag
    }
}

budget.__index = budget

function budget.new(args)
  local o = {}
  local cur_month = os.date("%b%Y")
  setmetatable(o, budget)
  if from_file then
    -- load from file. TODO
  else
    o.name = args.name
    o.transactions = {}
    o.transaction_tags = { "new", "savings", "income" } -- just a few to get started
    -- creates a table with the current month and a blank list of all transactions in it
    table.insert(o.transactions, { month = cur_month, {} } )
    o.fixed_expenses = args.fixed
    o.current_month = o.transactions[1].month
    o.current_month_index = 1
    o.savings = 0
    o.expenses = {
      monthly_avg = 0,
      history = { [cur_month] = 0, }
    }
    o.income = {
      monthly_avg = 0,
      history = { [cur_month] = 0, }
    }
    o.limits = { }
  end
  return o
end

-- if we're loading the budget from a file it has all the data it just needs its metatable set
function budget.new_from_file(table)
  setmetatable(table, budget)
  table.current_month = os.date("%b%Y")
  return table
end

-- self explanatory except for 'return_id'
-- return specifies whether or not the transaction object reference should be passed back to the call
-- mainly for the creation of a button to delete the transaction
function budget:add_transaction(tag, amount, month, return_id)
  -- if the tag is new...
  if not self:has_transaction_tag(tag) then
    table.insert(self.transaction_tags, tag)
    self.limits[tag] = 1
  end
  -- if we're adding a transaction to a new month...
  if not self.transactions[month] then
    self.transactions[month] = {}
  end
  local new_transaction = transaction.new(tag, amount)
  table.insert(self.transactions[month], new_transaction )
  -- special cases: savings and income
  -- all other tags go into expenses
  if tag == "savings" then
    self.savings = self.savings + amount
  elseif tag == "income" then
    self.income.history[month] = self.income.history[month] + amount
  else
    self.expenses.history[month] = self.expenses.history[month] + amount
  end
  if return_id then
    return new_transaction
  end
end

-- removes a specified transaction
-- takes a month and an id
function budget:remove_transaction(month, to_remove)
  print("removing id "..to_remove.id.." from "..month)
  for i = 1, #self.transactions[month] do
    if self.transactions[month][i].id == to_remove.id then
      if to_remove.tag == "income" then
        self.income.history[month] = self.income.history[month] - to_remove.amt
      elseif to_remove.tag == "savings" then
        self.savings = self.savings - to_remove.amt
      else
        self.expenses.history[month] = self.expenses.history[month] - to_remove.amt
      end
      table.remove(self.transactions[month], i)
      break
    end
  end
end

-- returns all transactions from a specific month
function budget:get_transactions(month)
  if self.transactions[month] then
    return self.transactions[month]
  else
    error("no data for month.."..month.." in budget", 2)
    return
  end
end

-- get a sum of all the fixed expenses
function budget:get_fixed_sum()
  local sum = 0
  for _ , amount in pairs(self.fixed_expenses) do
    sum = sum + amount
  end
  return sum
end

function budget:adjust_fixed_expense(expense, amount)
  self.fixed_expenses[expense] = amount
end

function budget:print_fixed_expenses()
  local t = ""
  for k, v in pairs(self.fixed_expenses) do
    t = t.."\t"..k..": "..v.."\n"
  end
  return t
end

-- get a sum of all variable expenses for the given month
function budget:get_variable_sum(month)
  if self.transactions[month] then
    local sum = 0
    for i = 1, #self.transactions[month] do
      if not self.transactions[month][i].tag == "income" then
        sum = sum + self.transactions[month][i].amt
      end
      return sum
    end
  else
    --error(month.." has no transactions/does not exist", 2)
    return 0
  end
end

function budget:get_income(month)
  return self.income.history[month]
end

function budget:get_variable_expenses(month)
  return self.expenses.history[month]
end

function budget:set_limit(tag, amount)
  print(tag.." "..amount)
  if self:has_transaction_tag(tag) then
    self.limits[tag] = amount
    print("limit for "..tag.." set to "..amount)
  end
end

function budget:save(amt)
  self.savings = self.savings + sum
end

function budget:withdraw_savings(amt)
  self.savings = self.savings - amt
end

-- switch month
-- takes a boolean indicated which direction to switch 
function budget:switch_month(foward)
  if forward then
    if self.transactions[self.current_month_index + 1] then
      self.current_month_index = self.current_month_index + 1
      self.current_month = self.transactions[self.current_month_index].month
    end
  else 
    if self.transactions[self.current_month_index - 1] then
      self.current_month_index = self.current_month_index - 1
      self.current_month = self.transactions[self.current_month_index].month
    end
  end
end

-- return whether or not the transaction tag already exists
function budget:has_transaction_tag(tag)
  for k, v in pairs(self.transaction_tags) do
    if tag == v then
      return true
    end
  end
  return false
end
