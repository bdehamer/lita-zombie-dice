require 'zdice/die'

module Zdice
  class Cup

    RAND = Random.new

    attr_reader :dice

    def self.json_create(o)
      new(o['dice'].map { |die| Zdice::Die.json_create(die) })
    end

    def initialize(dice=nil)
      if dice
        @dice = dice
      else
        reset
      end
    end

    def reset
      @dice = [
        Die.green, 
        Die.green, 
        Die.green, 
        Die.green, 
        Die.green, 
        Die.green, 
        Die.yellow, 
        Die.yellow, 
        Die.yellow, 
        Die.yellow,
        Die.red,
        Die.red,
        Die.red
      ]
    end

    def count
      @dice.size
    end

    def <<(die)
      @dice << die
    end

    def pick
      if @dice.size == 0
        raise 'No dice left in cup'
      end

      @dice.delete_at(RAND.rand(@dice.size))
    end

    def as_json
      {
        'dice' => @dice.map(&:as_json)
      }
    end
  end
end
