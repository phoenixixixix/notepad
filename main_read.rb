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
  # Получим строки для поста с помощью метода to_string и выведем их на экран
  puts "Запись #{result.class.name}, id = #{options[:id]}"

  # Получим строки для поста с помощью метода to_string и выведем их на экран
  result.to_strings.each do |line|
    puts line
  end
else
  # Если результат — это не один пост, а сразу несколько, показываем таблицу

  # Сначала — напечатаем шапку таблицы с названиями полей
  print '|id                  '
  print '| @type              '
  print '| @created_at        '
  print '| @text              '
  print '| @url               '
  print '| @due_date          '
  print '|'

  # Теперь для каждой строки из результатов выведем её в нужном формате
  result.each do |row|
    # Начинаем с пустой строки
  puts

  # Для каждого элемента строки выводим его в нужном формате.
  row.each do |element|
    # С палкой перед ним и обрезая первые 17 символов для очень длинных строк.
    # Также удаляем символы переноса.
    element_text = "| #{element.to_s.delete("\n")[0..17]}"

    # Если текст элемента короткий, добавляем нужное количество пробелов
    element_text << ' ' * (21 - element_text.size)
    print element_text
  end

    print '|'
  end

  puts
end
