# Description:
#   Invite people into the community!
# Commands:
#   hubot invite <email_address> - Sends an invite to the provided email address
# Author:
#   colmdoyle

slackKey = process.env.HUBOT_SLACK_ADMIN_TOKEN
unless slackKey?
  console.log "Missing Hubot Slack Token for admin script"

module.exports = (robot) ->
  robot.respond /invite (.*)/i, (msg) ->
    sender = msg.message.user.name.toLowerCase()
    console.log(msg.match[1])
    post_split = msg.match[1].split('|')
    if (post_split[1])
      email_address = post_split[1].slice(0,-1)
      if (email_address)
        data = "email=#{email_address}&channels=C035FCDDD&set_active=true&_attempts=1&token=#{slackKey}"
        console.log(data)
        robot.http("https://irishtechcommunity.slack.com/api/users.admin.invite?t=#{Date.now()}")
          .header('Accept', 'application/json')
          .header("Content-Type","application/x-www-form-urlencoded")
          .post(data) (err, res, body) ->
            data = JSON.parse(body)
            if (data.ok)
              console.log("#{sender} sent an invite to #{email_address}")
              msg.reply "Ok, I've sent an invite to #{email_address}"
            else
              if(data.error == 'already_invited')
                msg.reply "That email address has already been invited!"
              else if (data.error == 'sent_recently')
                msg.reply "Someone recently sent an invite to this email address"
              else
                msg.reply "Herp, something went wrong"
              console.log("#{sender} sent an invite to #{email_address}, but it failed")
              console.log(body)
              console.log(data)
    else
      msg.reply "Was that a valid email address?"
