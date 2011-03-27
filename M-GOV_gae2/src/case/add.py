from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

from Root import debugMode
from Constants import errorMsg

class AddCaseHandler(webapp.RequestHandler):
    def get(self):
        self.response.set_status(400)
        self.response.out.write(errorMsg(200, "Add doesn't support GET request."))
    
    def post(self):
        pass
    
app = webapp.WSGIApplication([(r'/case/add/', AddCaseHandler), (r'/case/add', AddCaseHandler)], debug=debugMode)

def main():
    run_wsgi_app(app)
    
if __name__=="__main__":
    main()