# frozen_string_literal: true

module Input
  def correct_input
    puts <<~MENU
      ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
      ║                                                 H E L P                                                   ║
      ╠═══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
      ║ Options                                                                                                   ║
      ║   1. Display the highest temperature and day, lowest temperature and day, most humid day and humidity.    ║
      ║      -e <yyyy> /path/to/filesFolder                                                                       ║
      ║         e.g. -e 2006 dubai_weather                                                                        ║
      ║   2. Display the average highest temperature, average lowest temperature, average humidity.               ║
      ║      -a <yyyy/mm> /path/to/filesFolder                                                                    ║
      ║         e.g. -a 2006/3 lahore_weather                                                                     ║
      ║   3. Draw two horizontal bar charts for the highest and lowest temperature on each day.                   ║
      ║      -c <yyyy/mm> /path/to/filesFolder                                                                    ║
      ║         e.g. -c 2006/2 murree_weather                                                                        ║
      ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
    MENU
  end

  def check_input(input)
    return if check_condition(input)

    puts 'ERROR: Please enter correct input'
    correct_input
    exit
  end

  # checks if correct format input is given at CLI
  def check_condition(input)
    !input[2].nil? && ((input[0] == '-e' && check_year_format(input[1])) ||
      ((input[0] == '-a' || input[0] == '-c') && check_month_format(input[1])))
  end

  # checks format yyyy/month
  def check_month_format(date)
    if date.match?(%r{^\d{4}/\d{2}$}) || date.match?(%r{^\d{4}/\d{1}$})
      parts = date.split('/')
      # checks if added month is within range
      return false if parts[1].to_i < 1 || parts[1].to_i > 12

      true
    else
      false
    end
  end

  # checks format yyyy
  def check_year_format(date)
    date.match?(/^\d{4}$/)
  end
end
