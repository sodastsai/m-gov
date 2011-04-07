# django 1.2
from google.appengine.dist import use_library
use_library("django", "1.2")

from google.appengine.ext import webapp
from google.appengine.ext.webapp import template
from google.appengine.ext.webapp.util import run_wsgi_app

import os

class StatisticalPage(webapp.RequestHandler):
    def get(self):
        htmlPath = os.path.join(os.path.dirname(__file__), "statistical.html")
        self.response.out.write(template.render(htmlPath, None))

application = webapp.WSGIApplication([('/html/statistical', StatisticalPage)],debug=True)

def main():
    run_wsgi_app(application)
    
if __name__ == "__main__":
    main()