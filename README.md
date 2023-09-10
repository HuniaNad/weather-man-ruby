# Weather Man

The WeatherMan application is a command-line tool designed to analyze weather data from different areas and time spans and generate various reports and charts. It can help you obtain insights into temperature and humidity patterns for specific years or months.

## Table of Contents

- [Dependencies](#dependencies)
- [Getting Started](#getting-started)

## Dependencies

To run this project, make sure you have the following dependencies installed:

- Ruby v2.7.8
- Colorize 

You can install Ruby using tools like RVM or rbenv. For Colorize, you can use the gem installer:

```bash
gem install colorize
```

## Getting Started

Follow these steps to set up the project on your local machine:

1. **Clone this repository:**

    ```bash
    git clone https://github.com/HuniaNad/weather-man-ruby.git
    cd weather-man-ruby
    ```

2. **Run the ruby project:**

   ```bash
    ruby main.rb <option>
    ```

      ### Options
      
      1. Use the `-e` option to display the highest temperature, lowest temperature, most humid day, and humidity for a specific year:
      
          ```shell
          #ruby main.rb -e <yyyy> /path/to/filesFolder
          ruby main.rb -e 2006 dubai_weather
          ```
         ![image](https://github.com/HuniaNad/weather-man-ruby/assets/44527785/894e4b7d-91b2-42e8-8037-a70601a65f62)
      
      2. Use the `-a` option to display the average highest temperature, average lowest temperature, and average humidity for a specific month/year:
      
          ```shell
          #ruby main.rb -a <yyyy/mm> /path/to/filesFolder
          ruby main.rb -a 2006/3 lahore_weather
          ```
          ![image](https://github.com/HuniaNad/weather-man-ruby/assets/44527785/47113329-3474-4f6d-a4bd-24da6d01edf8)
      
      3. Use the `-c option to draw two horizontal bar charts representing the highest and lowest temperatures for each day of a specific month/year:
         
          ```shell
          #ruby main.rb -c <yyyy/mm> /path/to/filesFolder
          ruby main.rb -c 2006/2 murree_weather
          ```
          ![image](https://github.com/HuniaNad/weather-man-ruby/assets/44527785/567ff23c-e430-4f1d-a528-b8f7db771787)




