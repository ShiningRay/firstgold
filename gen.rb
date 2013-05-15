# -*- encoding : utf-8 -*-
StatsFields=[:str, :agi, :spr, :int, :ac, :dmg1, :dmg2, :hp, :mp, :hr, :dr]
puts 'module StatsCalculations'
StatsFields.each do |n|
  puts <<method
  alias_method :#{n}_b,  :#{n}
  alias_method :#{n}_b=, :#{n}=
  def #{n}_b=(new_val)
    if #{n} != new_val
      #{n}=new_val
      update_#{n}_f
    end
  end

  def #{n}_a
    @addition[:#{n}]
  end

  def #{n}_a=(a)
    if @addition[:#{n}] != a
      @addition[:#{n}] = a
      update_#{n}_f
    end
  end

  def #{n}_p
    @percent[:#{n}]
  end

  def #{n}_p=(p)
    if @percent[:#{n}] != p
      @percent[:#{n}] = p
      update_#{n}_f
    end
  end
  def #{n}_f
    @final[:#{n}]
  end
  def update_#{n}_f
    @final[:#{n}] = (#{n}+#{n}_a)*(100+#{n}_p)/100
  end
  alias #{n} #{n}_f
method
end

puts 'end'
