# frozen_string_literal: true

require 'colorize'

module CustomOutput
  def custom_date(date, format, sep)
    months = %w[january february march april may june july august september october november december]
    date_parts = date.delete(' ').split(sep)
    if format == "yyyy#{sep}mm#{sep}dd"
      month = date_parts[1].to_i
      date = date_parts[2].to_i
      "#{months[month - 1].capitalize} #{date}"
    elsif format == "yyyy#{sep}mm"
      month = date_parts[1].to_i
      year = date_parts[0].to_i
      "#{months[month].capitalize} #{year}"
    end
  end

  def custom_temp(temp, unit)
    "#{temp.to_i}#{unit[0].upcase}"
  end

  def custom_percentage(percentage)
    percentage = (percentage.to_i * 100) / 100
    "#{percentage}%"
  end

  def show_high_temp_bar(row, temp)
    print "#{row[0].split('-')[2]} "
    temp.to_i.times do
      print '+'.red
    end
    print " #{temp.to_i}C\n"
  end

  def show_low_temp_bar(row, temp)
    print "#{row[0].split('-')[2]} "
    temp.to_i.times do
      print '+'.blue
    end
    print " #{temp.to_i}C\n"
  end

  def show_temp_bar(temp, color)
    temp.to_i.times do
      print '+'.colorize(:"#{color}")
    end
  end
end
