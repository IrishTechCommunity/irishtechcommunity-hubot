# Description:
#   List the community admins
# Commands:
#   hubot admins - Lists current admins
# Author:
#   colmdoyle

slackKey = process.env.HUBOT_SLACK_TOKEN
unless slackKey?
  console.log "Missing Hubot Slack Token for admin script"

admins = ''

module.exports = (robot) ->
  robot.respond /admins/i, (msg) ->
    robot.http("https://slack.com/api/users.list?token=#{slackKey}")
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        for member in data.members
          if member.is_admin is true
            admins += member.name
            admins += ' '
        msg.send "The current admins are #{admins}"
