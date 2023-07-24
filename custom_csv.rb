# frozen_string_literal: true

require 'csv'
require_relative 'custom_output'

class CustomCSV
  def initialize(file_name, delimiter, result, query_type)
    @file_name = file_name
    @delimiter = delimiter
    @result = result
    @query_type = query_type
    @headers = []
    @count = {}
  end

  # reading file's specific column data
  def read_file(*keys)
    CSV.foreach(@file_name, col_sep: @delimiter) do |row|
      # ignoring empty/null/extra lines
      next if row.empty? || row.nil? || row[0].include?('<!--')

      # file's required column indexes are saved
      if @headers.empty?
        @headers = get_headers_index(row, keys)
        next
      end
      get_result(row, keys)
      show_result(row) if @query_type == 3
    end
    @result
  end

  # fetches file's required column indexes
  def get_headers_index(row, keys)
    headers = {}
    keys.each do |key|
      index = row.find_index { |col| (col.downcase.delete(' ').include? key.to_s.downcase) }
      raise IndexError if index.nil?

      headers[key] = index
    end
    headers
  end

  # generates query search
  def get_result(row, keys)
    return initialize_result(row, keys) if @result.empty?

    keys.each do |key|
      comparisons(row, key) if @query_type == 1
      summation(row, key) if @query_type == 2
      update_result(row, key) if @query_type == 3
    end
  end

  def initialize_result(row, keys)
    keys.each { |key| update_result(row, key) }
  end

  def comparisons(row, key)
    max_comparison(row, key) if key.to_s.include? 'max'
    min_comparison(row, key) if key.to_s.include? 'min'
  end

  def max_comparison(row, key)
    col_value = row[@headers[key]]
    update_result(row, key) if !col_value.nil? && (col_value.to_f >= @result[key])
  end

  def min_comparison(row, key)
    col_value = row[@headers[key]]
    update_result(row, key) if !col_value.nil? && (col_value.to_f <= @result[key])
  end

  def summation(row, key)
    col_value = row[@headers[key]]
    return if col_value.nil?

    @result[:"#{key}_count"] += 1
    @result[key] += col_value.to_f
  end

  def update_result(row, key)
    @result[:"#{key}_day"] = row[0] if @query_type == 1
    @result[:"#{key}_count"] = 1 if @query_type == 2

    col_value = row[@headers[key]].to_f
    @result[key] = col_value
  end

  def show_result(row)
    output = Output.new
    # print_different_lines(output, row)
    print "#{row[0].split('-')[2]} "
    min_temp = @result[:minTemp].to_i
    max_temp = @result[:maxTemp].to_i
    output.show_temp_bar(min_temp, 'blue')
    output.show_temp_bar(max_temp, 'red')
    print " #{min_temp}C - #{max_temp}C\n"
  end

  def print_different_lines(output, row)
    @result.each do |key, value|
      output.show_high_temp_bar(row, value) if key.to_s.include? 'max'
      output.show_low_temp_bar(row, value) if key.to_s.include? 'min'
    end
  end
end
