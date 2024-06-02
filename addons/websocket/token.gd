extends Control

var salt = "ragna"
var passwd = "ragna"
var token = ""
var crypto = Crypto.new()
var tokens := {}
var	token_key = CryptoKey.new()
var	server_key = CryptoKey.new()
var	server_cert = X509Certificate.new()
var tokensfile = "./tokens"

func auth(peer_id, message):
	print("Received token from client ", peer_id, ": ", message)
	if tokens.has(message):
		print("Token validated for client ", peer_id)
		tokens[message].append(peer_id)
		return true
	print("Invalid token from client ", peer_id)
	return false

func validate(peer_id, message):
	if tokens[message].has(peer_id):
		return
	return auth(peer_id, message)

func _ready():
	tokens = JSON.parse_string( FileAccess.open(tokensfile, FileAccess.READ).get_as_text())

func _on_token_pressed():
	token = Marshalls.utf8_to_base64(passwd.sha1_text()).sha1_text()
	tokens[token] = []
	FileAccess.open(tokensfile,FileAccess.WRITE).store_string(JSON.stringify(tokens))
