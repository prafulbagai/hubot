# Commands
#	create server <server_name> password <root_password> group <group_name> plan <RAM_in_MB> auth <authorization_passphrase>- create a new server with the given properties
#	show info of server <server_name> - shows complete information about a server
#	<start/stop/restart> server <server_name> - start/stop/restart the given server
#	delete server <server_name> - delete the given server
#	please activate <project_name> of company <company_name> - Enable/Disable a project
#	resize server <server_name> to <RAM_in_MB>
#	lunch for today - tells what is in lunch for today

atmos_type = ["hot", "cold", "raining"]

child_process = require 'child_process'
console = require 'console'

module.exports = (robot) ->

	robot.respond /(hi|hello)/i, (res) ->
		res.send "Hi! How are you?"
		res.finish()

	robot.respond /how (are|is) (things|everything) going/i, (res) ->
		res.send "Not bad!\nEverything looks nice from here."
		res.finish()

	robot.hear /how are you/i, (res) ->
		res.send "I am good!"
		res.finish()

	robot.hear /i am good/i, (res) ->
		res.send "Good to hear that! :)"
		res.finish()

	robot.hear /you like/, (res) ->
		res.send "I like everyone!\nWhy should we hate anyone anyway?"
		res.finish()

	robot.hear /where are you/i, (res) ->
		res.send "Right now I'm in a cube. I like to call it \"The Tesseract\"!\nWhere are you?"
		res.finish()

	robot.hear /I am in (.*)/i, (res) ->
		atmo = res.random atmos_type
		res.send "Nice! Is it #{atmo} there?"
		res.finish()

	robot.respond /please activate (.*) of company (.*)/i, (res) ->
		proj_name = res.match[1]
		com_name = res.match[2]
		query = "curl -X POST 106.184.5.148/"+com_name+"/"+proj_name
		response = child_process.exec query, (error, stdout,stderr) ->
			result = JSON.parse(stdout)
			res.send result["response"]
		res.send("OK done!")
		res.send response.main.response
		res.finish()

	robot.respond /create server (.*) password (.*) group (.*) plan (.*) auth server_side_cube/i, (res) ->
		linode_name = res.match[1]
		linode_pass = res.match[2]
		linode_group = res.match[3]
		linode_plan = res.match[4]
		query = "linode create "+linode_name+" --password "+linode_pass+" --group "+linode_group+" --plan linode"+linode_plan
		res.send query
		child_process.exec query, (error, stdout, stderr) ->
			res.send stdout
		res.send "Ask 'show info of server server_name' to know ip when the system is booting"
		res.finish()

	robot.respond /show info of server (.*)/i, (res) ->
		linode_name = res.match[1]
		query = "linode show "+linode_name
		res.send query
		child_process.exec query, (error, stdout, stderr) ->
			res.send stdout
		res.finish()

	robot.respond /delete server (.*)/i, (res) ->
		linode_name = res.match[1]
		query = "linode delete "+linode_name
		res.send query
		child_process.exec query, (error, stdout, stderr) ->
			res.send stdout
		res.finish()

	robot.respond /start server (.*)/i, (res) ->
		linode_name = res.match[1]
		query = "linode start "+linode_name
		res.send query
		child_process.exec query, (error, stdout, stderr) ->
			res.send stdout
		res.finish()

	robot.respond /restart server (.*)/i, (res) ->
		linode_name = res.match[1]
		query = "linode restart "+linode_name
		res.send query
		child_process.exec query, (error, stdout, stderr) ->
			res.send stdout
		res.finish()

	robot.respond /stop server (.*)/i, (res) ->
		linode_name = res.match[1]
		query = "linode stop "+linode_name
		res.send query
		child_process.exec query, (error, stdout, stderr) ->
			res.send stdout
		res.finish()

	robot.respond /resize server (.*) to (.*)/i, (res) ->
		linode_name = res.match[1]
		new_plan = res.match[2]
		query = "linode resize "+linode_name+" linode"+new_plan
		res.send query
		child_process.exec query, (error, stdout, stderr) ->
			res.send stdout
		res.send "It generally takes about half an hour to complete in the background, be patient"
		res.finish()

	robot.respond /lunch for today/i, (res) ->
		query = "curl -X GET 139.162.222.17/show"
		data = child_process.exec query, (error, stdout, stderr) ->
			result = JSON.parse(stdout)
			res.send result["food"]
		res.finish()

	robot.hear /(.*)/i, (msg) ->
		msg.send "i don't know what you're saying... Please contact the admin!"
