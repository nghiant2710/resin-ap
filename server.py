from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer

PORT = 8000
 
class ServerHandler(BaseHTTPRequestHandler):
	
	#Handler for the GET requests
	def do_GET(self):
		self.send_response(200)
		self.send_header('Content-type','text/html')
		self.end_headers()
		self.wfile.write("Hello Resin !")
		return

try:
	server = HTTPServer(('', PORT), ServerHandler)
	print 'Server starts on port %s' %(PORT)
	server.serve_forever()

except KeyboardInterrupt:
	print '^C received, server is shutting down'
	server.socket.close()