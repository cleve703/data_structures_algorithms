# frozen_string_literal: true

class Node
  attr_accessor :data, :left_child, :right_child, :parent

  def initialize(data, parent)
    @data = data
    @left_child = nil
    @right_child = nil
    @parent = parent
  end
end

class Tree
  attr_accessor :array, :root, :level_order_data

  def initialize(array, name = nil)
    @name = name
    @root = nil
    @level_order_data = {}
    @level_order_array = []
    build_tree(array)
  end

  def build_tree(array)
    insert(array.delete_at(array.length / 2.floor))
    if array.length > 1
      build_tree(array[0...array.length / 2])
      build_tree(array[array.length / 2..-1])
    else
      build_tree(array) unless array.empty?
    end
  end

  def insert(num, node = @root)
    if num.class == Array
      build_tree(num) 
    elsif @root.nil?
      @root = Node.new(num, nil)
    else
      if num < node.data
        node.left_child.nil? ? node.left_child = Node.new(num, node) : insert(num, node.left_child)
      elsif num > node.data
        node.right_child.nil? ? node.right_child = Node.new(num, node) : insert(num, node.right_child)
      elsif num == node.data
      end
    end
  end

  def level_order_hash(node = @root, level_num = 1)
    @level_order_data.clear unless node != @root
    @level_order_data[level_num] = [] if @level_order_data[level_num].nil?
    @level_order_data[level_num].push(node.data)
    level_num += 1
    level_order_hash(node.left_child, level_num) unless node.left_child.nil?
    level_order_hash(node.right_child, level_num) unless node.right_child.nil?
    @level_order_data
  end

  def level_order(level = @root, &block)
    if block_given?
      block.call(level.data)
    else
      @level_order_array.push(level.data)
    end
    level_order(level.left_child, &block) unless level.left_child.nil?
    level_order(level.right_child, &block) unless level.right_child.nil?
    @level_order_array.join(',')
  end

  def delete(num, node = @root)
    if node.data == num
      if node.left_child.nil? && node.right_child.nil?
        change_node_parent_links(node, nil)
      elsif node.left_child.nil? && !node.right_child.nil?
        change_node_parent_links(node, node.right_child)
        node = node.right_child
      elsif !node.left_child.nil? && node.right_child.nil?
        change_node_parent_links(node, node.left_child)
        node = node.left_child
      elsif !node.left_child.nil? && !node.right_child.nil?
        temp = node.right_child
        change_node_parent_links(node, node.left_child)
        node = node.left_child
        node.right_child = temp
      end
    elsif num < node.data
      delete(num, node.left_child)
    elsif num > node.data
      delete(num, node.right_child)
    end
  end

  def change_node_parent_links(node, new_node)
    if node.parent.nil?
      new_node.parent = nil
      @root = new_node
    elsif node.parent.left_child == node
      node.parent.left_child = new_node
      node.parent = nil
    elsif node.parent.right_child == node
      node.parent.right_child = new_node
      node.parent = nil
    end
  end

  def inorder(node = @root, &block)
    if node.nil?
      nil
    else
      inorder(node.left_child, &block)
      if block_given?
        block.call(node.data)
      else
        puts node.data
      end
      inorder(node.right_child, &block)
    end
  end

  def preorder(node = @root, &block)
    if node.nil?
      nil
    else
      if block_given?
        block.call(node.data)
      else
        puts node.data
      end
      preorder(node.left_child, &block)
      preorder(node.right_child, &block)
    end
  end

  def postorder(node = @root, &block)
    if node.nil?
      nil
    else
      preorder(node.left_child, &block)
      preorder(node.right_child, &block)
      if block_given?
        block.call(node.data)
      else
        puts node.data
      end
    end
  end

  def depth(num)
    level_order_hash
    @level_order_data.find { |_key, values| values.include?(num) }.first
  end

  def balanced?(node = @root, level_num = 1)
    @leaf_levels = [] unless node != @root
    if node.left_child.nil? && node.right_child.nil?
      @leaf_levels.push(level_num)
    end
    level_num += 1
    balanced?(node.left_child, level_num) unless node.left_child.nil?
    balanced?(node.right_child, level_num) unless node.right_child.nil?
    @leaf_levels = @leaf_levels.uniq.sort
    if @leaf_levels.length > 2
      false
    elsif @leaf_levels.length == 1
      true
    elsif @leaf_levels[1] - @leaf_levels[0] == 1
      true
    elsif @leaf_levels[1] - @leaf_levels[0] > 1
      false
    end
  end

  def rebalance!
    array = []
    inorder(@root) do |item|
      array.push(item)
    end
    puts array
    @root = nil
    build_tree(array)
  end

  def to_s(item = @root)
    item_data = if item.nil?
                  'Nil'
                else
                  item.data
                end
    left_child_data = if item.left_child.nil?
                        'Nil'
                      else
                        item.left_child.data
                      end
    right_child_data = if item.right_child.nil?
                         'Nil'
                       else
                         item.right_child.data
                       end
    puts "Data: #{item_data} - Left: #{left_child_data} - Right: #{right_child_data}."
    to_s(item.left_child) unless item.left_child.nil?
    to_s(item.right_child) unless item.right_child.nil?
  end
end