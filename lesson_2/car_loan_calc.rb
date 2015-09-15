
def prompt(message)
  puts "=> #{message} <="
end

def invalid_loan_amount?(num)
  num.empty? || num.to_f <= 0
end

def invalid_rate?(num)
  num.empty? || num.to_f <= 0
end

def invalid_loan_duration?(num)
  num.empty? || num.to_f <= 0
end


prompt("Welcome to the fancy-dancy Car Loan Calculator!")
prompt("Please provide us with your name for the best service possible.")

name = ''
loop do
  name = gets.chomp
  if name.empty?
    prompt("No, really. Please give us your name.")
  else
    break
  end
end

prompt("Thanks, #{name}. Let's get started!")

loop do
  loan_amount = ''
  loop do
    prompt("What is the total amount of your loan? Please leave off the dollar sign.")
    loan_amount = gets.chomp
    if invalid_loan_amount?(loan_amount)
      prompt("Please provide the loan amount in the proper format.")
    else
      break
    end
  end

  rate = ''
  loop do
    prompt("What is the Interest Rate on the loan? (Please enter the percentage as a decimal - 5% as .05)")
    rate = gets.chomp
    if invalid_rate?(rate)
      prompt("Please provide the rate in the proper format. Ex 6% => .06")
    else
      break
    end
  end

  loan_duration_years = ''
  loop do
    prompt("Finally, how many years is the loan?")
    loan_duration_years = gets.chomp
      if invalid_loan_duration?(loan_duration_years)
        prompt("Please provide the loan duration in 'years'.")
      else
        break
      end
  end

  monthly_interest_rate = rate.to_f / 12
  loan_duration_months = loan_duration_years.to_i * 12

  monthly_loan_payment = loan_amount.to_f * (monthly_interest_rate * (1 + monthly_interest_rate) ** loan_duration_months.to_i) / ((1 + monthly_interest_rate) ** loan_duration_months.to_i - 1)

  prompt("Your monthly loan payment will be $#{monthly_loan_payment}")

  prompt("Would you like to make another payment caluculation?")
  break unless gets.chomp.downcase.start_with?('y')
end

prompt("Thanks for using my fancy-dancy Car Loan Calculator, #{name}!")
