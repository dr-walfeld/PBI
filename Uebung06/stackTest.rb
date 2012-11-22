#!/usr/bin/env ruby
# encoding: utf-8
require "./stack.rb"
require "test/unit"
require 'pp'

# diese ist die Funktion, um zu sehen, ob der Stack funktioniert.
class StackUnitTest < Test::Unit::TestCase
  def setup
    @stack = Stack.new()
  end
  def test1_push_pop
    #test variables
    oben = nil
    wert = nil

    puts "100 mal push/pop testen"
    (1..100).each do |i|
      @stack.push(i)
    end

    100.downto(1) do |i|
  # empty testen
      assert(!@stack.empty?, "ERROR: stack should not be empty!")

  # top testen
      assert_nothing_raised "ERROR: stack should not be empty!." do
        oben = @stack.top()
      end
      assert_equal(i, oben,"ERROR: expected #{i}, got #{oben}!")

  # pop testen
      assert_nothing_raised "ERROR: stack should not be empty!." do
        wert = @stack.pop()
      end
      assert_equal(i, wert, "ERROR: expected #{i}, got #{wert}!")
    end
  end

  def test2_empty
    assert_send([@stack, :empty?],"ERROR: stack should be empty!")
  end

  def test3_push_pop2
    #test variables
    wert = nil
    puts "50 mal push, 25 mal pop testen"
    (1..50).each do |i|
      @stack.push(i)
    end
    50.downto(25) do |i|
      assert_nothing_raised "ERROR: stack should not be empty!." do
        wert = @stack.pop()
      end
      assert_equal(i, wert, "ERROR: expected #{i}, got #{wert}!")
    end
  end

  def test4_push_pop3
    #test variables
    wert = nil
    puts "100 mal push testen"
    (1..100).each do |i|
      @stack.push(i)
    end

    100.downto(1).each do |i|
      assert_nothing_raised "ERROR: stack should not be empty!." do
        wert = @stack.pop()
      end
      assert_equal(i, wert, "ERROR: expected #{i}, got #{wert}!")
    end
  end

  def test5_empty_stash
    #test variables
    wert = nil
    puts "den Stack leer machen "
    i=24

    (1..24).each do |i|
      @stack.push(i)
    end
    while not @stack.empty? do
      assert_nothing_raised "ERROR: stack should not be empty!." do
        wert = @stack.pop()
      end
      assert_equal(i, wert, "ERROR: expected #{i}, got #{wert}!")
      i -= 1
    end
  end

  def test6_empty_raise
    assert_raise RuntimeError, "ERROR: stack should throw exeption if empty" do
      @stack.top()
    end
    assert_raise RuntimeError, "ERROR: stack should throw exeption if empty" do
      @stack.pop()
    end
  end
end

Test::Unit::AutoRunner.run

def test()
  stack = Stack.new
  begin
    stack.pop
  rescue
    puts "Exception caught!"
  end
end

test()
