main_window = {}

function main_window.load(budget)
  my_budget = budget
  loveframes.SetState("main")
  
  -- overall panel
  local frame = loveframes.Create("frame")
  frame:SetName("Budget")
  frame:SetSize(1024, 768)
  frame:SetState("main")
  frame:SetDraggable(false):ShowCloseButton(false):SetAlwaysOnTop(true)
  
  -- list of transactions
  local transactions_title = loveframes.Create("text", frame)
  transactions_title:SetText("Transactions:")
  transactions_title:SetState("main")
  transactions_title:SetPos(5, 30)
  
  local transactions = loveframes.Create("list", frame)
  transactions:SetSize(250, 720)
  transactions:SetState("main")
  transactions:SetPos(5, 45)
  if my_budget.transactions[my_budget.current_month] then
    for i = 1, #my_budget.transactions[my_budget.current_month] do
      local t = my_budget.transactions[my_budget.current_month][i]
      local newtrans = loveframes.Create("text")
      newtrans:SetText("$"..t.amt..", "..t.tag.." \tentered "..t.date)
      if tag == "income" then newtrans:SetDefaultColor(0,200,0) end
      transactions:AddItem(newtrans)
    end
  end

  -- limits setting area
  local limits_label = loveframes.Create("text", frame)
  limits_label:SetPos(260, 160)
  limits_label:SetText("Enter Budget Limits By Tag")
  limits_label:SetState("main")
  
  local limits_panel = loveframes.Create("panel", frame)
  limits_panel:SetPos(260, 180)
  limits_panel:SetState("main")
  limits_panel:SetSize(400, 35)
  
  -- select limit to modify
  local limit_selector = loveframes.Create("multichoice", limits_panel)
  limit_selector:SetPos(85, 5)
  limit_selector:SetState("main")
  limit_selector:SetWidth(120)
  for i = 1, #my_budget.transaction_tags do
    if not ( my_budget.transaction_tags[i] == "new" or my_budget.transaction_tags[i] == "income" or my_budget.transaction_tags[i] == "savings") then
      limit_selector:AddChoice(my_budget.transaction_tags[i])
    end
  end
  
  -- entry box for limit
  local limit_entry = loveframes.Create("textinput", limits_panel )
  limit_entry:SetPos(5, 5)
  limit_entry:SetWidth(75)
  limit_entry:SetText("0")
  limit_entry:SetState("main")
  limit_entry:SetEditable(true)
  
  -- button 
  local limit_button = loveframes.Create("button", limits_panel)
  limit_button:SetPos(315, 5)
  limit_button:SetText("Set Limit")
  limit_button:SetState("main")
  
  -- place to enter new transactions
  local transaction_entry_label = loveframes.Create("text", frame)
  transaction_entry_label:SetText("Enter New Transaction")
  transaction_entry_label:SetState("main")
  transaction_entry_label:SetPos(260, 30)
  
  local transaction_entry_panel = loveframes.Create("panel", frame)
  transaction_entry_panel:SetSize(400, 110)
  transaction_entry_panel:SetPos(260, 45)
  transaction_entry_panel:SetState("main")
  
  local variable_transaction_label = loveframes.Create("text", transaction_entry_panel)
  variable_transaction_label:SetPos(5, 5)
  variable_transaction_label:SetText("New Variable Expense/Income/Savings Transaction:")
  variable_transaction_label:SetState("main")
  
  -- add value entry
  local value_entry = loveframes.Create("textinput", transaction_entry_panel)
  value_entry:SetPos(5, 25)
  value_entry:SetWidth(75)
  value_entry:SetText("0")
  value_entry:SetState("main")
  value_entry:SetEditable(true)
  
  -- add tag select
  -- see 'transaction button' for addition of new tags
  local transaction_tag_select = loveframes.Create("multichoice", transaction_entry_panel )
  transaction_tag_select:SetPos(85, 25)
  transaction_tag_select:SetWidth(120)
  for i = 1, #my_budget.transaction_tags do
    transaction_tag_select:AddChoice(my_budget.transaction_tags[i])
  end
  transaction_tag_select:SetState("main")
  
  -- add new tag
  local transaction_tag_add = loveframes.Create("textinput", transaction_entry_panel)
  transaction_tag_add:SetPos(210, 25)
  transaction_tag_add:SetWidth(100)
  transaction_tag_add:SetText("")
  transaction_tag_add:SetEditable(true)
  transaction_tag_add:SetState("main")
  
  -- add transaction button
  local transaction_entry_button = loveframes.Create("button", transaction_entry_panel )
  transaction_entry_button:SetText("Add")
  transaction_entry_button:SetPos(315, 25)
  transaction_entry_button:SetState("main")
  transaction_entry_button.OnClick = 
    function() 
      local tag, amount = ""
      local date = os.date("%b %d")
      if transaction_tag_select:GetChoice() == "new" then
        if not my_budget:has_transaction_tag(transaction_tag_add:GetText()) then
          transaction_tag_select:AddChoice(transaction_tag_add:GetText())
          limit_selector:AddChoice(transaction_tag_add:GetText())
        end
        my_budget:add_transaction(
          transaction_tag_add:GetText(), 
          value_entry:GetText(), 
          my_budget.current_month ) 
        tag = transaction_tag_add:GetText()
        amount = value_entry:GetText()
      else
        my_budget:add_transaction(
          transaction_tag_select:GetChoice(), 
          value_entry:GetText(), 
          my_budget.current_month ) 
        tag = transaction_tag_select:GetChoice()
        amount = value_entry:GetText()
      end
      local newtrans = loveframes.Create("text")
      newtrans:SetText("$"..amount..", "..tag.." \tentered "..date)
      if tag == "income" then newtrans:SetDefaultColor(0,200,0) end
      transactions:AddItem(newtrans)
    end
    
  -- fixed expense area
  local fixed_expense_label = loveframes.Create("text", transaction_entry_panel)
  fixed_expense_label:SetText("New/Adjust Fixed Expense:")
  fixed_expense_label:SetPos(5, 55)
  fixed_expense_label:SetState("main")
  
  -- select fixed expense
  local fixed_expense_select = loveframes.Create("multichoice", transaction_entry_panel )
  fixed_expense_select:SetPos(85, 75)
  fixed_expense_select:SetWidth(120)
  fixed_expense_select:AddChoice("new")
  for k, v in pairs(my_budget.fixed_expenses) do
    fixed_expense_select:AddChoice(k)
  end
  fixed_expense_select:SetState("main")
  
  -- fixed expense value
  local fixed_value_entry = loveframes.Create("textinput", transaction_entry_panel)
  fixed_value_entry:SetPos(5, 75)
  fixed_value_entry:SetWidth(75)
  fixed_value_entry:SetText("0")
  fixed_value_entry:SetState("main")
  fixed_value_entry:SetEditable(true)
  
  -- add new fixed expense
  local add_fixed_expense = loveframes.Create("textinput", transaction_entry_panel)
  add_fixed_expense:SetPos(210, 75)
  add_fixed_expense:SetWidth(100)
  add_fixed_expense:SetText("")
  add_fixed_expense:SetEditable(true)
  add_fixed_expense:SetState("main")
  
  -- button to add new fixed expense
  local fixed_expense_entry_button = loveframes.Create("button", transaction_entry_panel )
  fixed_expense_entry_button:SetText("Add/Edit")
  fixed_expense_entry_button:SetPos(315, 75)
  fixed_expense_entry_button:SetState("main")
  fixed_expense_entry_button.OnClick = 
    function() 
      if fixed_expense_select:GetChoice() == "new" then
        if not my_budget.fixed_expenses[add_fixed_expense:GetText()] then
          fixed_expense_select:AddChoice(add_fixed_expense:GetText())
        end
        my_budget:adjust_fixed_expense(add_fixed_expense:GetText(), fixed_value_entry:GetText())
      else
        my_budget:adjust_fixed_expense(fixed_expense_select:GetChoice(), fixed_value_entry:GetText())
      end
    end
  
  -- general budget data area
  local budget_summary = loveframes.Create("panel", frame)
  budget_summary:SetPos(665, 45)
  budget_summary:SetSize(353, 25)
  budget_summary:SetState("main")
  
  local budget_summary_text = loveframes.Create("text", budget_summary)
  budget_summary_text:SetPos(5, 5)
  budget_summary_text:SetText("")
  budget_summary_text.Update = 
    function(object)
      local to_print = ""
      to_print = to_print.." Avg. Variable: $?"
      to_print = to_print.." Avg. Income: $?"
      to_print = to_print.." Savings: $"..my_budget.savings
      object:SetText(to_print)
    end
  
  local budget_info_panel = loveframes.Create("panel", frame)
  budget_info_panel:SetPos(665, 75)
  budget_info_panel:SetSize(353, 140)
  budget_info_panel:SetState("main")
  
  local budget_info_label = loveframes.Create("text", frame)
  budget_info_label:SetText("Summary for \""..my_budget.name.."\" for "..my_budget.current_month)
  budget_info_label:SetPos(665, 30)
  budget_info_label:SetState("main")
  
  local budget_save = loveframes.Create("button", budget_info_panel)
  budget_save:SetText("Save Budget")
  budget_save:SetPos(265, 5)
  budget_save.OnClick = 
    function()
      util.save_table(my_budget, my_budget.name..".txt")
    end
  
  local budget_load = loveframes.Create("button", budget_info_panel)
  budget_load:SetText("Load Budget")
  budget_load:SetPos(265, 35)
  budget_load.OnClick = 
    function()
      loveframes.SetState("choose")
    end

  local budget_info_text = loveframes.Create("text", budget_info_panel)
  budget_info_text:SetText("")
  budget_info_text:SetPos(5, 5)
  budget_info_text:SetState("main")
  budget_info_text.Update = function(object) 
      local to_print = ""
      to_print = to_print.."Fixed Expenses: $"..my_budget:get_fixed_sum().."\n\n"
      to_print = to_print..my_budget:print_fixed_expenses().."\n"
      object:SetText(to_print)
    end
  end