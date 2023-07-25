# frozen_string_literal: true

require_relative 'user_input'
require_relative 'custom_csv'
require_relative 'output'

class WeatherMean
  include CustomCSV
  def initialize(argv)
    @argv = argv
  end

  def main
    input = UserInput.new(@argv)
    # input validation check
    input = input.main
    # run query based on the cli input
    query_result(input)
  end

  def query_result(input)
    run_query(input)
    return unless [1, 2].include?(input[:query])

    display = Output.new(@result)
    display.display_normal_result(input[:query])
  end

  def run_query(input)
    run_query1(input) if input[:query] == 1
    run_query2(input) if input[:query] == 2
    run_query3(input) if input[:query] == 3
  end

  # -e query
  def run_query1(input)
    year, path = input.values_at(:year, :file)
    directory_path = "./files/#{path}*"

    # Find all files in the directory that contain the custom string in their path
    matching_files = Dir.glob(File.join(directory_path, "**/*#{year}*"))
    @result = {}
    # Read the content of each matching file
    matching_files.each do |file_path|
      set_module_variables(file_path, ',', 1)
      @result = read_file(:maxTemp, :minTemp, :maxHumid)
    end
  end

  # -a query
  def run_query2(input)
    year, month, path = input.values_at(:year, :month, :file)
    directory_path = "./files/#{path}*"

    # Find all files in the directory that contain the custom string in their path
    matching_files = Dir.glob(File.join(directory_path, "**/*#{year}*#{month}*"))
    @result = {}
    # Read the content of each matching file
    matching_files.each do |file_path|
      set_module_variables(file_path, ',', 2)
      @result = read_file(:maxTemp, :minTemp, :meanHumid)
    end
    average
  end

  # -c query
  def run_query3(input)
    year, month, path = input.values_at(:year, :month, :file)
    display_date(input, year)
    directory_path = "./files/#{path}*"

    # Find all files in the directory that contain the custom string in their path
    matching_files = Dir.glob(File.join(directory_path, "**/*#{year}*#{month}*"))
    puts 'Data not found!' if matching_files.empty?
    # Read the content of each matching file
    matching_files.each do |file_path|
      set_module_variables(file_path, ',', 3)
      read_file(:maxTemp, :minTemp)
    end
  end

  def set_module_variables(file_path, delimiter, query)
    @file_name = file_path
    @delimiter = delimiter
    @query_type = query
  end

  def display_date(input, year)
    input_obj = UserInput.new(input)
    # gets month value
    month_value = input_obj.fetch_month('i')
    output_obj = Output.new
    # displays custom date on console
    puts output_obj.custom_date("#{year}-#{month_value}", 'yyyy-mm', '-')
  end

  # calculates average for query#2 when summations are returned for each column value
  def average
    @result.each do |key, value|
      next if key.to_s.include? 'count'

      denom = @result[:"#{key}_count"]
      @result[key] = value / denom unless denom.zero?
    end
  end
end

# command line inputs
runner = WeatherMean.new(ARGV)
runner.main
