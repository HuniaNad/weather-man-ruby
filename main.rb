# frozen_string_literal: true

require_relative 'user_input'
require_relative 'custom_csv'
require_relative 'output'

def main(argv)
  input = UserInput.new(argv)
  # input validation check
  input = input.main
  # run query based on the cli input
  query_result(input)
end

def query_result(input)
  result = run_query(input)
  return unless [1, 2].include?(input[:query])

  display = Output.new(result)
  display.display_normal_result(input[:query])
end

def run_query(input)
  # run specific queries based on input
  result = run_query1(input) if input[:query] == 1
  result = run_query2(input) if input[:query] == 2
  run_query3(input) if input[:query] == 3
  result
end

# -e query
def run_query1(input)
  year, path = input.values_at(:year, :file)
  directory_path = "./files/#{path}*"

  # Find all files in the directory that contain the custom string in their path
  matching_files = Dir.glob(File.join(directory_path, "**/*#{year}*"))
  result = {}
  # Read the content of each matching file
  matching_files.each do |file_path|
    my_csv = CustomCSV.new(file_path, ',', 1, result)
    result = my_csv.read_file(:maxTemp, :minTemp, :maxHumid)
  end
  result
end

# -a query
def run_query2(input)
  year, month, path = input.values_at(:year, :month, :file)
  directory_path = "./files/#{path}*"

  # Find all files in the directory that contain the custom string in their path
  matching_files = Dir.glob(File.join(directory_path, "**/*#{year}*#{month}*"))
  result = {}
  # Read the content of each matching file
  matching_files.each do |file_path|
    my_csv = CustomCSV.new(file_path, ',', 2, result)
    result = my_csv.read_file(:maxTemp, :minTemp, :meanHumid)
  end
  average(result)
end

# -c query
def run_query3(input)
  year, month, path = input.values_at(:year, :month, :file)
  display_date(input, year)
  directory_path = "./files/#{path}*"

  # Find all files in the directory that contain the custom string in their path
  matching_files = Dir.glob(File.join(directory_path, "**/*#{year}*#{month}*"))
  # Read the content of each matching file
  matching_files.each do |file_path|
    my_csv = CustomCSV.new(file_path, ',', 3) # puts file_name
    my_csv.read_file(:maxTemp, :minTemp)
  end
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
def average(result)
  result.each do |key, value|
    next if key.to_s.include? 'count'

    result[key] = value / result[:"#{key}_count"]
  end
  result
end

# command line inputs
main(ARGV)
