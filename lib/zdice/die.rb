module Zdice
  class Die

    RED = %i(brain blast blast blast runner runner)
    YELLOW = %i(brain brain blast blast runner runner)
    GREEN = %i(brain brain brain blast runner runner)
    RAND = Random.new
    private_constant :RED, :YELLOW, :GREEN, :RAND

    attr_reader :color, :value

    def self.red
      new(:red)
    end

    def self.yellow
      new(:yellow)
    end

    def self.green
      new(:green)
    end

    def self.json_create(o)
      new(o['color'], o['value'])
    end

    def initialize(color, value=nil)
      @color = color.to_sym
      @faces = case @color
               when :red
                 RED
               when :yellow
                 YELLOW
               when :green
                 GREEN
               else
                 raise "Not a valid die color"
               end
      @value = value ? value.to_sym : nil
    end

    def roll
      @value = @faces[RAND.rand(6)]
    end

    def to_s
      "#{@color}#{@value}"
    end
  
    def as_json
      {
        'color' => color,
        'value' => value
      }
    end
  end
end
