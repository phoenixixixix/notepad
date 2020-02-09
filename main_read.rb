require_relative 'lib/post'
require_relative 'lib/link'
require_relative 'lib/task'
require_relative 'lib/memo'

#id, limit, type

require 'optparse'

# Опции будут записаны тут
options = {}

OptionParser.new do |opt|
  # Этот текст будет выводиться, когда программа запущена с опцией -h
  opt.banner = 'Usage: read.rb [options]'

  # Вывод в случае, если запросили help
  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  # Опция --type будет передавать тип поста, который мы хотим считать
  opt.on('--type POST_TYPE', 'какой тип постов показывать ' \
         '(по умолчанию любой)') { |o| options[:type] = o }

  # Опция --id передает номер записи в базе данных (идентификатор)
  opt.on('--id POST_ID', 'если задан id — показываем подробно ' \
         ' только этот пост') { |o| options[:id] = o }

  # Опция --limit передает, сколько записей мы хотим прочитать из базы
  opt.on('--limit NUMBER', 'сколько последних постов показать ' \
         '(по умолчанию все)') { |o| options[:limit] = o }

  # В конце у только что созданного объекта класс OptionParser вызываем
  # метод parse, чтобы он заполнил наш хэш options в соответствии с правилами.
end.parse!

result = Post.find(options[:limit], options[:type], options[:id])

if result.is_a?(Post)
  puts "Запись #{result.class.name}, id = #{options[:id]}"

  result.to_strings.each do |line|
    puts line
  end
else # Покажем таблицу результатов
  print "| id\t| @type\t| @created_at\t\t\t| @text\t\t\t| @url\t\t| @due_date \t"

  result.each do |row|
    puts

    row.each do |element|
      print "| #{element.to_s.delete('\\n\\r')[0..40]}\t"
    end
  end
end

puts
