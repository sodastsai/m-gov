# Django 1.2
from google.appengine.dist import use_library
use_library('django', '1.2')

from google.appengine.ext import webapp
from google.appengine.ext.webapp import template
from google.appengine.ext.webapp.util import run_wsgi_app

import os

from Constants import errorMsg, errorDict

debugMode = True

class RootPage(webapp.RequestHandler):
    def get(self):
        # Convert Error Dict for Django display
        errorList = []
        for item in errorDict:
            errorList += [{"code":item , "msg":errorDict[item]}]
        # Make Django render html and output
        templateDict = { "errorDict": errorList }
        path = os.path.join(os.path.dirname(__file__), 'document/main.html')
        self.response.out.write(template.render(path, templateDict)) 

## This webapp handler will show example
class ExamplePage(webapp.RequestHandler):
    def get(self):
        if self.request.get("category")=="":
            self.response.out.write(errorMsg(202, "category is required."))
            return
        templateDict = {"category": self.request.get("category")}
        htmlPath = os.path.join(os.path.dirname(__file__), "document/example.html")
        self.response.out.write(template.render(htmlPath, templateDict))

application = webapp.WSGIApplication([('/',RootPage), ('/example/', ExamplePage)],debug=True)

def main():
    run_wsgi_app(application)    
    
if __name__ == "__main__":
    main()    