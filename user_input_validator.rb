# frozen_string_literal: true

require_relative 'input'
class UserInputValidator
  include Input

  def initialize(input)
    @input = input
    @query = {}
    @query1 = '-e'
    @query2 = '-a'
    @query3 = '-c'
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
    @query[:query] = @input.first
    fetch_month if @input.first == @query2 || @input.first == @query3
    fetch_year
    fetch_file
  end

  def fetch_year
    @query[:year] = @input[1].split('/')[0]
  end

  def fetch_month(mode = '')
    months = Date::ABBR_MONTHNAMES
    # if mode is 'i', it returns month number. Otherwise, returns month string
    return months.find_index(@input[:month]) - 1 if mode.casecmp('i').zero?

    month_value = @input[1].split('/')[1].to_i
    @query[:month] = months[month_value]
  end

  def fetch_file
    @query[:file] = @input[2]
  end
end
