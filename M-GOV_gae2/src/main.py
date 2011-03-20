from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext.webapp import template
import os

class MainPage(webapp.RequestHandler):
    def get(self):
        template_values = {
        }
        
        path = os.path.join(os.path.dirname(__file__),'main.html')
        self.response.out.write(template.render(path,template_values)) 


application = webapp.WSGIApplication([('/',MainPage)],debug=True)

def main():
    run_wsgi_app(application)
    
    
if __name__ == "__main__":
    main()    