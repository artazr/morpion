module Morpion
  class Board
    attr_accessor :boxes
    attr_accessor :alignments
​
​
    def initialize
​
      self.boxes = (0 .. 9).map { |i| (0 .. 9).map { |j| Box.new(i: i, j: j) } }
                      
      self.alignments = []
      
      (0 .. 9).each do |i|
        (0 .. 5).each do |j|
          al = Alignment.new
          (0 .. 4).each { |offset| box( i, j+offset ).belongs_to(al) }
          self.alignments << al
        end
      end
​
      .....
​
​
    end
​
    def box(i,j)
      boxes[i][j]
    end
​
​
  end
​
  class Box
    attr_accessor :i, :j, :player, :alignments
​
    def initialize(i:,j:)
      self.i = i
      self.j = j
      self.player = :none
      self.alignments = []
    end
​
    def belongs_to(alignment)
      alignment.boxes << self
      alignments << alignment
    end
    
  end
​
  class Alignment
    attr_accessor :boxes
​
​
    def initialize
      self.boxes = []
    end
    
  end