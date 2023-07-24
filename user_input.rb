# frozen_string_literal: true

require_relative 'input'
class UserInput
  include Input

  def initialize(input)
    @input = input
    @query = {}
  end

  def main
    # correct input is being checked to continue with the program flow. Otherwise, code exits
    check_input(@input)
    # input details are fetched separately
    fetch_input
    # input details are returned as Hash object
    @query
  end

  # stores CLI input values separately in a Hash object
  def fetch_input
    if @input[0] == '-e'
      @query[:query] = 1
    elsif @input[0] == '-a'
      @query[:query] = 2
      fetch_month
    else
      @query[:query] = 3
      fetch_month
    end
    fetch_year
    fetch_file
  end

  def fetch_year
    @query[:year] = @input[1].split('/')[0]
  end

  def fetch_month(mode = '')
    months = %w[jan feb mar apr may jun jul aug sep oct nov dec]
    # if mode is 'i', it returns month number. Otherwise, returns month string
    return months.find_index(@input[:month]) if mode.casecmp('i').zero?

    month_value = @input[1].split('/')[1].to_i
    @query[:month] = months[month_value - 1]
  end

  def fetch_file
    @query[:file] = @input[2]
  end
end
