extends Node

signal make_request
signal resign_from_request

onready var Hrequest = $HTTPRequest
var making_request = false
var request_error = null

func _ready():
	connect("make_request",self,"_on_make_request")
	connect("resign_from_request",self,"_on_resign_from_request")


#func _process(delta):
#	if making_request:
#		print(Hrequest.get_http_client_status())

func _on_make_request():
	if making_request:
		print("still requesting")
		return
#	request_error=Hrequest.request("http://www.google.com")
	request_error=Hrequest.request("https://8.8.8.8",[],false)
	making_request = true

func _on_resign_from_request():
	if making_request:
		Hrequest.cancel_request()
		making_request = false

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	making_request = false
	if request_error != OK:
		print("sth goes wrong with request_error")
		print("requested error is: " + str(request_error))
		print("result is: " + str(result))
		get_parent().get_node("VBoxSevedScores").show()
	elif result != 0:
		print("sth goes wrong with result")
		print("requested error is: " + str(request_error))
		print("result is: " + str(result))
		get_parent().get_node("VBoxSevedScores").show()
	else:
		print("successfully connected")
		get_parent().load_rewarded()
		get_parent().get_node("Comment_4_Net").hide()







