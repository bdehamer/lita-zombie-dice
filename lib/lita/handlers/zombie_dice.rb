require 'zdice/player'
require 'json'

module Lita
  module Handlers
    class ZombieDice < Handler
      route(/^new-game/, :new_game)
      route(/^roll/, :roll)
      route(/^pass/, :pass)

      def new_game(response)
        if response.args
          save_player_list(response.args)
          response.args.each do |arg|
            save_player(Zdice::Player.new(arg))
          end
        else
          save_player(Zdice::Player.new(response.user.mention_name))
        end

        player = current_player
        response.reply("#{player.name}'s turn")
      end

      def roll(response)
        return unless pre(response)

        player = current_player
        hand = player.roll 
        response.reply("(#{hand[0]}) (#{hand[1]}) (#{hand[2]})")

        if player.blasted?
          end_turn(player)
          response.reply("You're dead!")
          sleep(1.0/2.0)
          response.reply("#{current_player.name}'s turn")
        else
          save_player(player)
        end
      end

      def pass(response)
        return unless pre(response)

        player = current_player
        end_turn(player)
        response.reply("#{player.name}'s score: #{player.score}")
        sleep(1.0/2.0)
        response.reply("#{current_player.name}'s turn")
      end

      def end_turn(player)
        player.end_turn
        save_player(player)
        rotate_players
      end

      def pre(response)
        ok = true
        player = current_player

        if current_player.name != response.user.mention_name
          response.reply("#{response.user.mention_name}, it's not your turn!")
          ok = false
        end

        ok
      end

      def save_player_list(players=[])
        redis.del("player_list")
        redis.del("current_player")
        players.each do |p|
          redis.rpush("player_list", p)
          redis.rpush("current_player", p)
        end
      end

      def get_player_list
        redis.get("player_list")
      end

      def rotate_players
        name = redis.lpop("current_player")
        redis.rpush("current_player", name)
      end

      def current_player
        name = redis.lrange("current_player", 0, 0).first
        get_player(name)
      end

      def get_player(name="default")
        p = JSON.parse(redis.get("players/#{name}"))
        Zdice::Player.json_create(p)
      end

      def save_player(player)
        redis.set("players/#{player.name}", player.as_json.to_json)
      end
    end

    Lita.register_handler(ZombieDice)
  end
end
