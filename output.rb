# frozen_string_literal: true

require_relative 'output_utility'

class Output
  include OutputUtility

  def initialize(result = {})
    @result = result
  end

  def display_normal_result(query)
    if empty?(@result)
      puts 'Data not found!'
    else
      display_maxtemp(query)
      display_mintemp(query)
      display_humidity(query)
    end
  end

  def display_maxtemp(query)
    print "\nHighest: #{custom_temp(@result[:maxTemp], 'c')}"
    display_day(:maxTemp_day) if query == 1
  end

  def display_mintemp(query)
    print "\nLowest: #{custom_temp(@result[:minTemp], 'c')}"
    display_day(:minTemp_day) if query == 1
  end

  def display_humidity(query)
    print "\nHumid: #{custom_percentage(@result[:maxHumid])}" if query == 1
    print "\nHumid: #{custom_percentage(@result[:meanHumid])}" if query == 2
    display_day(:maxHumid_day) if query == 1
  end

  def display_day(key)
    print " on #{custom_date(@result[key], 'yyyy-mm-dd', '-')}"
  end

  def empty?(result)
    result.empty? || result.nil?
  end
end
