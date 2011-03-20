from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext.webapp import template
import os
from google.appengine.api import urlfetch

class MainPage(webapp.RequestHandler):
    def get(self):
        url = "http://www.czone2.tcg.gov.tw/GMaps/desc.cfm?sn=09912-704897";
        result = urlfetch.Fetch(url)
        if result.status_code == 200:
            self.response.out.write(result.content)
        else:
            self.response.out.write(result.content)


application = webapp.WSGIApplication([('/fetch',MainPage)],debug=True)

def main():
    run_wsgi_app(application)
    
    
if __name__ == "__main__":
    main()    