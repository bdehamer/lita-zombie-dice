require 'zdice/cup'

module Zdice
  class Player

    attr_reader :score, :table

    def self.json_create(o)
      table = o['table'] ? o['table'].map { |die| Zdice::Die.json_create(die) } : [] 
      hold = o['hold'] ? o['hold'].map { |die| Zdice::Die.json_create(die) } : [] 
      cup = o['cup'] ? Zdice::Cup.json_create(o['cup']) : nil
      score = o['score']
      new(table, hold, cup, score)
    end

    def initialize(table=[], hold=[], cup=Cup.new, score=0)
      @table = table
      @hold = hold
      @cup = cup
      @score = score
    end

    def start_turn
      @table = []
      @hold = []
      @cup = Cup.new
      nil
    end

    def roll
      hand = @hold
      (3 - hand.size).times do 
        puts "Adding new die"
        hand << @cup.pick
      end

      @hold = []
      hand.each do |die|
        die.roll

        if die.value == :runner
          @hold << die
        else
          @table << die
        end
      end
      
      hand
    end

    def end_turn
      blasts = 0
      brains = 0

      @table.each do |die|
        case die.value
        when :brain
          brains += 1
        when :blast
          blasts += 1
        end
      end

      if blasts < 3
        @score += brains
      end

      @table = []
      @hold = []
      nil
    end

    def blasted?
      @table.count { |die| die.value == :blast } >= 3
    end

    def as_json
      {
        score: score,
        cup: @cup ? @cup.as_json : nil,
        table: @table ? @table.map(&:as_json) : [],
        hold: @hold ? @hold.map(&:as_json) : []
      }
    end
  end
end
