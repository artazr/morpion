module Morpion
	class Box
	    attr_accessor :i, :j, :player
		def initialize(i:,j:)
		  self.i = i
		  self.j = j
		  self.player = :none						
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
	class Board 
		attr_accessor :boxes
		def initialize
			self.boxes = []
			(0 .. 9).each do |i|
				self.boxes << (0 .. 9).map { |j| Box.new(i: i, j: j) }
			end
			puts "\n Veuillez commencer le jeu, entrez la commande"
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

		def checkrow (row)
			response =""
				(0..9).each do |j|
					response += "#{self.boxes[row][j]}"
				end
			if 	response.include?("XXXXX") 
				puts "Le joueur 1 à gagné par ligne"
				@fin = true
			elsif response.include?("OOOOO")
				puts "Le joueur 2 à gagné par ligne"
				@fin = true
			end
		end

		def checkcol (col)
			response = ""
				(0..9).each do |i|
					response += "#{self.boxes[i][col]}"
				end
			if 	response.include?("XXXXX") 
				puts "Le joueur 1 à gagné par colonne"
				@fin = true
			elsif response.include?("OOOOO")
				puts "Le joueur 2 à gagné par colonne"
				@fin = true
			end
		end

		def is_game_over
			@fin
		end


		def checkdiag_sup_right(diag, j)
			response = ""
			computerwin = "XXXXX"
			userwin = "OOOOO"
			if j == 0
				(diag-4..9).each do |i|				
					response += "#{self.boxes[i][i-diag+4]}"
				end
			elsif j == 1
				(0..9).each do |i|	
					response += "#{self.boxes[i][9+i-diag]}"
				end
			end
			if 	response.include?("XXXXX") 
				puts "Le joueur 1 à gagné par diag"
				@fin = true
			elsif response.include?("OOOOO")
				puts "Le joueur 2 à gagné par diag"
				@fin = true
			end
		end
		

		def checkdiag_sup_left(diag, j)
			response = ""
			computerwin = "XXXXX"
			userwin = "OOOOO"
			if j == 0
				(0..diag).each do |i|				
					response += "#{self.boxes[i][diag-i]}"
				end
			elsif j == 1
				(0..9).each do |i|	
					response += "#{self.boxes[9-i][9+i-diag]}"
				end
			end
			if 	response.include?("XXXXX") 
				puts "Le joueur 1 à gagné par diag"
				@fin = true
			elsif response.include?("OOOOO")
				puts "Le joueur 2 à gagné par diag"
				@fin = true
			end
		end

		def turn(i, j)
			if @myturn
				self.boxes[i][j].player = :user
				@myturn = false
				"C'est maintenant au tour du joueur 2 de rentrer des coordonnées"
			else
				self.boxes[i][j].player = :computer
				#@myturn = true
				"C'est maintenant au tour du joueur 1 de rentrer des coordonnées"
			end
		end

	end

	class Game
		attr_accessor :board
		def initialize
			self.board = Board.new
		end

		def turn(i, j)
			if self.board.is_game_over 
				puts "Fin du jeu"
			elsif self.board.boxes[i][j].player == :none
				puts self.board.turn(i, j)
				show_board
			else
				print "Cette case est déja prise"
				puts
				show_board
			end

			(0..9).each do |i|
				self.board.checkrow(i)
			end
			(0..9).each do |i|
				self.board.checkcol(i)
			end

			(0..1).each do |j|
				(4..9).each do |i|
					self.board.checkdiag_sup_right(i, j)
				end
			end
			
			(0..1).each do |j|
				(4..9).each do |i|
					self.board.checkdiag_sup_left(i, j)
				end
			end
		end

		def fullfill
			(0..9).each do |i|
				(0..9).each do |j|
					self.board.boxes[i][j]="O"
				end

			end
			show.board
		end

		def fivefill
			(0..5).each do |j|
				self.board.boxes[3][j]="O"
			end
			show_board
		end

		def show_board
			puts self.board
		end
		def checkrow
			self.board.checkrow
		end
	end
end