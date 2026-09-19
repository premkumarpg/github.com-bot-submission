import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

APP_NAME = os.getenv("APP_NAME", "demo")
VERSION = os.getenv("VERSION", "0.1.0")

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/healthz":
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(b"{\"status\":\"ok\"}")
            return
        if self.path == "/":
            body = json.dumps({
                "app": os.getenv("APP_NAME", APP_NAME),
                "version": os.getenv("VERSION", VERSION),
                "pod": os.uname().nodename,
            }).encode()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(body)
            return
        self.send_response(404)
        self.end_headers()

    def log_message(self, fmt, *args):
        print(fmt % args, flush=True)

if __name__ == "__main__":
    ThreadingHTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
