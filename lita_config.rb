Lita.configure do |config|
  # The name your robot will use.
  config.robot.name = "Hu Bot"
  config.robot.mention_name = "hu"

  # The locale code for the language to use.
  # config.robot.locale = :en

  # The severity of messages to log. Options are:
  # :debug, :info, :warn, :error, :fatal
  # Messages at the selected level and above will be logged.
  config.robot.log_level = :debug

  # An array of user IDs that are considered administrators. These users
  # the ability to add and remove other users from authorization groups.
  # What is considered a user ID will change depending on which adapter you use.
  #config.robot.admins = ["95214_729822@chat.hipchat.com"]

  # The adapter you want to connect with. Make sure you've added the
  # appropriate gem to the Gemfile.
  #config.robot.adapter = :hipchat

  ## Example: Set options for the Redis connection.
  config.redis.host = "redis"
  config.redis.port = 6379

end
