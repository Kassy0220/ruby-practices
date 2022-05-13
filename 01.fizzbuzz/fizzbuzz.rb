# コマンドライン上で与えられた引数が2つ以外の時、処理を終了する
def check_arguments(stdin)
  if stdin.length <2
    puts "数値は2つ入力してください"
    exit
  elsif stdin.length > 2
    puts "数値は2つ入力してください"
    exit
  end
end

def check_fizzbuzz(number)
  return number if number == 0

  if number % 3 == 0 && number % 5 == 0
    "FizzBuzz"
  elsif number % 3 == 0
    "Fizz"
  elsif number % 5 == 0
    "Buzz"
  else
    number
  end
end

def output_fizzbuzz(stdin)
  check_arguments(stdin)
  # 整数に変換
  stdin.map! {|n| n.to_i}
  # sort!で昇順にしてから取り出す
  first = stdin.sort!.shift
  last = stdin.shift

  number_range = Range.new(first, last)
  number_range.each {|n| puts check_fizzbuzz(n)}
end

stdin = ARGV
output_fizzbuzz(stdin)
