# frozen_string_literal: true

require 'csv'
module CustomCSV
  @file_name = 'w'
  @delimiter = ','
  @result = {}
  @query_type = ''
  @headers = []
  @count = {}

  # reads file's specific column data
  def read_file(*keys)
    @result = {} if @query_type == @query3
    # set_module_variables(filename, delimiter, query, result)
    CSV.foreach(@file_name, col_sep: @delimiter) do |row|
      # ignoring empty/null/extra lines
      next if row.empty? || row.nil? || row[0].include?('<!--')

      # file's required column indexes are saved
      if @headers.nil?
        @headers = get_headers_index(row, keys)
        next
      end
      get_result(row, keys)
      show_result(row) if @query_type == @query3
    end
    @result
  end

  # fetches file's required column indexes
  def get_headers_index(row, keys)
    headers = {}
    begin
      keys.each do |key|
        # finds index of column which matches with passed key symbols
        index = row.find_index { |col| (col.downcase.delete(' ').include? key.to_s.downcase) }
        raise IndexError if index.nil?

        headers[key] = index
      end
    rescue IndexError
      puts 'ERROR: Index not found!'
    end
    headers
  end

  # generates query result
  def get_result(row, keys)
    return initialize_result(row, keys) if @result.empty?

    keys.each do |key|
      comparisons(row, key) if @query_type == @query1
      summation(row, key) if @query_type == @query2
      update_result(row, key) if @query_type == @query3
    end
  end

  # initializes @result when it is empty
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
    @result[:"#{key}_day"] = row[0] if @query_type == @query1
    @result[:"#{key}_count"] = 1 if @query_type == @query2
    col_value = row[@headers[key]].to_f
    @result[key] = col_value
  end

  def show_result(row)
    output = Output.new
    # result_on_different_lines(output, row)
    result_on_same_line(output, row)
  end

  # method to print the high and low temperatures on separate lines
  def result_on_different_lines(output, row)
    @result.each do |key, value|
      output.show_high_temp_bar(row, value) if key.to_s.include? 'max'
      output.show_low_temp_bar(row, value) if key.to_s.include? 'min'
    end
  end

  # method to print the high and low temperatures on same line
  def result_on_same_line(output, row)
    print "#{row[0].split('-')[2]} "
    min_temp = @result[:minTemp].to_i
    max_temp = @result[:maxTemp].to_i
    output.show_temp_bar(min_temp, 'blue')
    output.show_temp_bar(max_temp, 'red')
    print " #{min_temp}C - #{max_temp}C\n"
  end
end
