# Description:
#   Invite people into the community!
# Commands:
#   hubot invite <email_address> - Lists current admins
# Author:
#   colmdoyle

slackKey = process.env.HUBOT_SLACK_ADMIN_TOKEN
unless slackKey?
  console.log "Missing Hubot Slack Token for admin script"

module.exports = (robot) ->
  robot.respond /invite (.*)/i, (msg) ->
    email_address = encodeURIComponent(msg.match[1])
    data = "email=#{email_address}&channels=C035FCDDD&set_active=true&_attempts=1&token=#{slackKey}"
    console.log(data)
    robot.http("https://irishtechcommunity.slack.com/api/users.admin.invite?t=#{Date.now()}")
      .header('Accept', 'application/json')
      .header("Content-Type","application/x-www-form-urlencoded")
      .post(data) (err, res, body) ->
        console.log(body)
        data = JSON.parse(body)
        msg.send "#{data.ok}"
        if (data.ok)
          msg.reply "Ok, I've sent an invite to #{email_address}"
        else
          msg.reply "Herp, something went wrong"
