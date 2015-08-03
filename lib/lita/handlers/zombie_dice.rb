require 'zdice/player'
require 'json'

module Lita
  module Handlers
    class ZombieDice < Handler
      route(/^new-game/, :new_game)
      route(/^roll/, :roll)
      route(/^pass/, :pass)
      route(/^score/, :score)

      def new_game(response)
        response.reply('yo yo yo')
        player = Zdice::Player.new
        save_player(player)
      end

      def roll(response)
        player = get_player
        hand = player.roll 
        response.reply("(#{hand[0]}) (#{hand[1]}) (#{hand[2]})")

        if player.blasted?
          response.reply("You're dead!")
          player.end_turn
        end

        if player.score >= 13
          response.reply("You win!")
          player.end_turn
        end

        save_player(player)
      end

      def pass(response)
        player = get_player
        player.end_turn
        player.start_turn
        save_player(player)
      end

      def score(response)
        player = get_player
        response.reply("Score: #{player.score}")
      end

      def get_player
        p = JSON.parse(redis.get("players/1"))
        Zdice::Player.json_create(p)
      end

      def save_player(player)
        redis.set("players/1", player.as_json.to_json)
      end
    end

    Lita.register_handler(ZombieDice)
  end
end
