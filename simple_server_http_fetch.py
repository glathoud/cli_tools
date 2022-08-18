#!/usr/bin/env python3

import http.server
import os.path
import socket
import socketserver
import subprocess
import sys
import threading
import time
import urllib.request

N_THREAD = 10

PORT = 8123 if len( sys.argv ) < 2 else int( sys.argv[ 1 ] )

print( "About to serve HTTP at port", PORT )

#

class CORSRequestHandler (http.server.SimpleHTTPRequestHandler):

    def _set_headers( self, extra_headers=[] ):
        self.send_response(200)
        for x in extra_headers:
            #print(x[0])
            #print(x[1])
            self.send_header( x[ 0 ], x[ 1 ] )
            
        self.end_headers()

    def do_GET (self):
        p = self.path.split( '?' )[ 0 ]

        FETCH = '/fetch/'
        if p.startswith( FETCH ):

            url = p[ len(FETCH): ]

            self._set_headers( extra_headers=[

                [ 'Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' ],
                [ 'Accept-Encoding', 'gzip, deflate, br' ],
                [ 'Accept-Language', 'en-US,en;q=0.9,fr;q=0.8,de;q=0.7,fi;q=0.6,it;q=0.5' ],
                [ 'Cache-Control', 'no-cache' ],
                [ 'Pragma', 'no-cache' ],
                [ 'Sec-Fetch-Dest', 'document' ],
                [ 'Sec-Fetch-Mode', 'navigate' ],
                [ 'Sec-Fetch-Site', 'none' ],
                [ 'Sec-Fetch-User', '?1' ],
                [ 'Upgrade-Insecure-Requests', '1' ],
                [ 'User-Agent', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36' ]
            ] )

            #response = urllib.request.urlopen( url )
            #contents = response.read()

            r = subprocess.run(["curl", "--http2", url], stdout=subprocess.PIPE)
            contents = r.stdout if r.returncode == 0 else '__failed:r.returncode:' + r.returncode + '__'
            
            print( "contents loaded, beginning: ", contents[0:min(len(contents),100)])
            
            return self.wfile.write( contents )
        
        return http.server.SimpleHTTPRequestHandler.do_GET( self )

    def end_headers (self):
        self.send_header('Access-Control-Allow-Origin', '*')
        http.server.SimpleHTTPRequestHandler.end_headers(self)

#

class ThreadingSimpleServer( socketserver.ThreadingMixIn, http.server.HTTPServer ):
    pass

# Create ONE socket.
addr = ('', PORT)
sock = socket.socket (socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind(addr)
sock.listen(5)

# Launch N_THREAD listener threads.
# based on https://stackoverflow.com/questions/14088294/multithreaded-web-server-in-python/51559006#51559006
class Thread(threading.Thread):
    def __init__(self, i):
        threading.Thread.__init__(self)
        self.i = i
        self.daemon = True
        self.start()
    def run(self):

        httpd = ThreadingSimpleServer(('localhost', PORT)
                                      , CORSRequestHandler
                                      , False)
        
        
        # Prevent the HTTP server from re-binding every handler.
        # https://stackoverflow.com/questions/46210672/
        httpd.socket = sock
        httpd.server_bind = self.server_close = lambda self: None
        
        httpd.serve_forever()

#

[Thread(i) for i in range(N_THREAD)]

while True:
    time.sleep(10);

