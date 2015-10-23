module Morpion
	class Box
	    attr_accessor :i, :j, :player, :alignments
		def initialize(i:,j:)
		  self.i = i
		  self.j = j
		  self.player = :none
		  self.alignments = []					
		end

		def belongs_to(alignment)
      alignment.boxes << self
      alignments << alignment
    end

		def to_s
      case player
      when :user
        "X"
      when :computer
        "O"
      when :none
        "."
      end     
		end   
	end


	class Alignment
    	attr_accessor :boxes
    def initialize
      self.boxes = []
    end

    def is_won?
    	v = boxes.map(&:player).uniq
    	v.count == 1 && v.first != :none
    end

    def is_tie?
    	t = boxes.map(&:player).uniq
    	t.count < 2
    end
  end


	class Board 
			attr_accessor :boxes
    	attr_accessor :alignments

		def initialize
			self.boxes = []
			(0 .. 9).each do |i|
				self.boxes << (0 .. 9).map { |j| Box.new(i: i, j: j) }
			end

			self.alignments = []
      
      (0 .. 9).each do |i|
        (0 .. 5).each do |j|
          row = Alignment.new
          (0 .. 4).each { |offset| box( i, j+offset ).belongs_to(row) }
          self.alignments << row
        end
      end

      (0..9).each do |i|
      	(0..5).each do |j|
      		col = Alignment.new
      		(0..4).each { |offset| box(j+offset, i).belongs_to(col)}
      		self.alignments << col 
    		end
    	end

    	(0..5).each do |i|
    		(0..5).each do |j|
    			diag_sup_right = Alignment.new
    			(0..4).each do |offset|
    				box(offset+i, j+offset).belongs_to(diag_sup_right)
    			end
    			self.alignments << diag_sup_right 
    		end
    	end

    	(0..5).each do |i|
    		(0..5).each do |j|
    			diag_inf_left = Alignment.new
    			(0..4).each do |offset|
    				box(j+offset, 9-(i+offset)).belongs_to(diag_inf_left)
    			end
    			self.alignments << diag_inf_left
    		end
    	end
		end 

    def find_best_boxes
    	weight_user = [nil,2,5,10,20]
    	weight_computer = [1,2,4,9,19]
    	weight_boxes = []
    	weight_box = 0
    	weight_each_al = 0
    	price = 0
    	(0..9).each do |i|
    		(0..9).each do |j|
    			box(i,j).alignments.each do |al|
    				(0..al.boxes.count).each do |each_al|
	    				a = each_al.boxes.map(&:player)
	    				if a.include?('user')
	    					price += weight_user[a.include?('user').count]
	    				else
		    				price += weight_computer[a.include?('computer').count]
		    			end
	    			weight_each_al += price
	    			end
	    		end
	    		weight_box += weight_each_al
	    		weight_boxes <<  weight_box
	    	end
	    end
	    puts weight_boxes
	  end

	# def all_alignments_per_box
  #     (0 .. 9).each do |i|
  #       (0 .. 9).each do |j|
  #         box(i,j).alignments.each do |al|
  #           al.boxes.each do |box|
  #             box.player = :user
  #           end
  #         end
  #         puts self
  #         box(i,j).alignments.each do |al|
  #           al.boxes.each do |box|
  #             box.player = :none
  #           end
  #         end
  #       end
  #     end
  #   end

		def box(i,j)
      boxes[i][j]
    end

		def to_s
			str = " -----------------------------------------\n"
			(0..9).each do |i|
				(0..9).each do |j|
					str += " | #{self.boxes[i][j]}"
				end
				str += " | \n ----------------------------------------- \n"
			end
			str
		end

		def is_game_over
			result = alignments.select{|a| a.is_won?}
			result.count > 0
		end

		def is_tie
			result = alignments.select{|t| t.is_tie?}
			result.count > 0
		end

	end

	class Game
			attr_accessor :board

		def initialize
			self.board = Board.new
		end

		def turn(i, j)
			if i == "lourd" && j == "de_ouf"
				puts "C'est gagné"
			elsif self.board.is_game_over
					puts "Vous avez fini cette partie \n 
					Vous devez recommencer une partie"
			elsif !self.board.is_tie
					puts "Égalité, vous devez recommencer une partie"
			elsif i<11 && j<11 && self.board.box(i,j).player == :none
					puts self.player(i, j)
			elsif i>10 || j>10
					puts "Tu n'est pas dans le tableau \n 
					Rentre un nombre inférieur à 10"
			elsif i<11 && j<11 && self.board.box(i,j).player != :none
				puts "Cette case est déja prise, essaie encore"
			else 
				puts "Que passa ???"
			end
		end

		def player(i, j)
			if @myturn
				board.box(i,j).player = :user
				if self.board.is_game_over
					puts "C'est gagné"
				elsif !self.board.is_tie
					puts "Égalité"
				else
					@myturn = false
					"C'est maintenant au joueur 2 de rentrer des coordonnées"
				end
			else
				board.box(i,j).player = :computer
				if self.board.is_game_over
					puts "C'est gagné"
				elsif !self.board.is_tie
					puts "Égalité"
				else
					@myturn = true
					"C'est maintenant au joueur 1 de rentrer des coordonnées"
				end
			end
			show_board
		end

		def tmp_fivefill
			(0..5).each do |j|
				self.board.boxes[3][j]="O"
			end
			show_board
		end

		def show_board
			puts self.board
		end
	end

end