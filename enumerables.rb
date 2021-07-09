module Enumerable
  def my_each
    i = 0
    while i < length
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
    self
  end

  def my_select
    select = []
    my_each do |ele|
      select << ele if yield(ele)
    end
    select
  end

  def my_all?
    my_each do |ele|
      return false unless yield(ele)
    end
    true
  end

  def my_any?
    my_each do |ele|
      return true if yield(ele)
    end
    false
  end

  def my_none?
    my_each do |ele|
      return false if yield(ele)
    end
    true
  end

  def my_count(*arg, &proc)
    return sum { |i| proc.call(i) ? 1 : 0 } if block_given?

    return length if arg.empty?

    raise ArgumentError, "wrong number of arguments (given #{arg.size}, expected 1" if arg.size > 1

    h = Hash.new(0)

    each do |i|
      h[i] += 1
    end

    h[arg[0]]
  end

  def my_map(&proc)
    new_arr = []
    my_each do |ele|
      new_arr << proc.call(ele)
    end
    new_arr
  end

  def my_inject(*args)
    operators = %i[+ - * /]
    result = 1
    first_value = args.first

    if operators.include?(first_value) && !block_given? && args.size == 1
      case first_value
      when :+
        result = 0
        to_a.my_each { |i| result += i }
      when :-
        result = to_a.first
        to_a.drop(1).my_each { |i| result -= i }
      when :/
        result = to_a.first
        to_a.drop(1).my_each { |i| result /= i }
      else
        to_a.my_each { |i| result *= i }
      end
    elsif args.size == 2 || args.size == 1 && block_given?
      result = first_value
      to_a.my_each do |ele|
        result = yield(result, ele)
      end
    elsif block_given?
      result = to_a.first
      to_a.drop(1).my_each do |ele|
        result = yield(result, ele)
      end
    end

    result
  end
end

def multiple_els(arr)
  arr.my_inject(:*)
end

# [1, 3, 5].my_each { |item| puts item }
# [11, 223, 54].my_each_with_index do |item, idx|5 /
#   puts "Index #{idx}"
#   puts "Item #{item}"
# end

# p [22, 34, 55, 6].my_any? { |num| num > 35 }
# p [22, 34, 55, 6].my_select { |num| num > 35 }
# p [0, 1, 2].my_none? { |num| num > 3 }
# p [22, 34, 555, 222].my_map { |i| i + 2 }
# p [1, 3, 4, 22, 1, 22].my_count { |i| i > 21 }

# p (5..10).my_inject { |acc, e| acc *= e }
p multiple_els([2,4,5])
