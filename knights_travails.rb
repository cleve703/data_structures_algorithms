class Node

  attr_accessor :coord, :level, :child1, :child2, :child3, :child4, :child5, :child6, :child7, :child8, :parent

  def initialize(coord, level, parent)
    @coord = coord
    @level = level
    @child1 = nil
    @child2 = nil
    @child3 = nil
    @child4 = nil
    @child5 = nil
    @child6 = nil
    @child7 = nil
    @child8 = nil
    @parent = parent
  end

end

class Game

  attr_reader :board_coord, :start_point, :solutions

  def initialize
    @board_coord = []
    x = 0
    while x < 8
      y = 0
      while y < 8
        @board_coord.push([x,y])
        y += 1
      end
    x += 1
    end
  end
    
  def knight_moves(start_point, stop_point)
    @start_point = Node.new(start_point, 0, nil)
    @queue = []
    @queue.unshift(@start_point)
    @stop_point = stop_point
    @match_level = nil  
    @valid_moves = @board_coord
    @solutions = []
    build_tree
  end

  def build_tree
    while @queue.length > 0
      point = @queue.pop
      create_children(point)
    end
  end

  def create_children(point)
    if @match_level.nil? || point.level < @match_level
      if @valid_moves.include?([point.coord[0] + 1, point.coord[1] + 2])
        point.child1 = Node.new([point.coord[0] + 1, point.coord[1] + 2], point.level + 1, point)
        @queue.unshift(point.child1)
        @solutions.push(point.child1) if point.child1.coord == @stop_point
      end
      if @valid_moves.include?([point.coord[0] + 2, point.coord[1] + 1])
        point.child2 = Node.new([point.coord[0] + 2, point.coord[1] + 1], point.level + 1, point)
        @queue.unshift(point.child2)
        @solutions.push(point.child2) if point.child2.coord == @stop_point
      end
      if @valid_moves.include?([point.coord[0] + 1, point.coord[1] - 2])
        point.child3 = Node.new([point.coord[0] + 1, point.coord[1] - 2], point.level + 1, point)
        @queue.unshift(point.child3)
        @solutions.push(point.child3) if point.child3.coord == @stop_point
      end
      if @valid_moves.include?([point.coord[0] + 2, point.coord[1] - 2])
        point.child4 = Node.new([point.coord[0] + 2, point.coord[1] - 1], point.level + 1, point)
        @queue.unshift(point.child4)
        @solutions.push(point.child4) if point.child4.coord == @stop_point
      end
      if @valid_moves.include?([point.coord[0] - 1, point.coord[1] - 2])
        point.child5 = Node.new([point.coord[0] - 1, point.coord[1] - 2], point.level + 1, point)
        @queue.unshift(point.child5)
        @solutions.push(point.child5) if point.child5.coord == @stop_point
      end
      if @valid_moves.include?([point.coord[0] - 2, point.coord[1] - 1])
        point.child6 = Node.new([point.coord[0] - 2, point.coord[1] - 1], point.level + 1, point)
        @queue.unshift(point.child6)
        @solutions.push(point.child6) if point.child6.coord == @stop_point
      end
      if @valid_moves.include?([point.coord[0] - 1, point.coord[1] + 2])
        point.child7 = Node.new([point.coord[0] - 1, point.coord[1] + 2], point.level + 1, point)
        @queue.unshift(point.child7)
        @solutions.push(point.child7) if point.child7.coord == @stop_point
      end
      if @valid_moves.include?([point.coord[0] - 2, point.coord[1] + 1])
        point.child8 = Node.new([point.coord[0] - 2, point.coord[1] + 1], point.level + 1, point)
        @queue.unshift(point.child8)
        @solutions.push(point.child8) if point.child8.coord == @stop_point
      end
    end  
    if point.coord == @stop_point
      @match_level = point.level + 1 unless !@match_level.nil?
    elsif @match_level.nil? || point.level < @match_level
      build_tree
    end
  end

  def display_solutions
    @solution_hash = {}
    i = 1
    @solutions.each do |solution|
      retrace_parents(solution)
      @solution_hash[i] = @temp_array
      i += 1
    end
    puts( @solution_hash.map{ |k,v| "#{k} => #{v}" }.sort )
  end

  def retrace_parents(node, array = [])
    array.unshift(node.coord.to_a)
    retrace_parents(node.parent, array) unless node.parent.nil?
    if node.parent.nil?
      @temp_array = array
    end
  end
  
end