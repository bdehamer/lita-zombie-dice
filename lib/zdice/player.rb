require 'zdice/cup'

module Zdice
  class Player

    attr_reader :name, :score, :table

    def self.json_create(o)
      name = o['name']
      table = o['table'] ? o['table'].map { |die| Zdice::Die.json_create(die) } : [] 
      hold = o['hold'] ? o['hold'].map { |die| Zdice::Die.json_create(die) } : [] 
      cup = o['cup'] ? Zdice::Cup.json_create(o['cup']) : nil
      score = o['score']
      new(name, table, hold, cup, score)
    end

    def initialize(name="", table=[], hold=[], cup=Cup.new, score=0)
      @name = name
      @table = table
      @hold = hold
      @cup = cup
      @score = score
    end

    def roll
      hand = @hold
      dice_needed = 3 - hand.size

      if dice_needed > @cup.count
        refill_cup
      end

      dice_needed.times do 
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
      @cup = Cup.new
      nil
    end

    def refill_cup
      @table.each do |die|
        if die.value == :brain
          @cup << Die.new(die.color)
        end
      end
    end

    def blasted?
      @table.count { |die| die.value == :blast } >= 3
    end

    def as_json
      {
        name: name,
        score: score,
        cup: @cup ? @cup.as_json : nil,
        table: @table ? @table.map(&:as_json) : [],
        hold: @hold ? @hold.map(&:as_json) : []
      }
    end
  end
end
