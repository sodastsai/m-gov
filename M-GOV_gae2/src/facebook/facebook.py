
from google.appengine.ext import db
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template
from google.appengine.ext.webapp import util
import urllib
from google.appengine.api import urlfetch
from django.utils import simplejson as json
import os

class Cznoe_Fb_Table(db.Model):
    caseid = db.StringProperty()
    postid = db.StringProperty()

class HomeHandler(webapp.RequestHandler):
    def get(self):

        template_values={}
        
        path = os.path.join(os.path.dirname(__file__),"facebook.html")
        self.response.out.write(template.render(path,template_values))


class do_wall_post(webapp.RequestHandler):
    def post(self):
            access_token = self.request.get('access_token')
            message = self.request.get('message')
            link = self.request.get('link')
            name = self.request.get('name')
            caption = self.request.get('caption')
            description = self.request.get('description')

            form_fields = {
              "access_token": access_token,
              "message": message,
              "link": link,
              "name":name,
              "caption":caption,
              "description":description,
            }

            form_data = urllib.urlencode(form_fields)
            result = urlfetch.fetch(url="https://graph.facebook.com/me/feed",
                        payload=form_data,
                        method=urlfetch.POST,
                        headers={'Content-Type': 'application/x-www-form-urlencoded'})
        
            if result.status_code == 200:
                
                obj = json.loads(result.content)

                cft = Cznoe_Fb_Table()
                cft.caseid = self.request.get('caseid')
                cft.postid = obj['id']
                cft.put() 
                
                self.response.out.write(result.content)
            else:
                pass # TODO:

class get_post_id(webapp.RequestHandler):
    def get(self):
        postid = self.request.get('postid')
        

def main():
    util.run_wsgi_app(webapp.WSGIApplication([("/facebook", HomeHandler),
                                              ("/facebook/do_wall_post",do_wall_post),
                                              ("/facebook/get_post_id",get_post_id)
                                              ]))


if __name__ == "__main__":
    main()


#106524439416118|ebad76ab32f81cbb944154e3-504741038|aO52USRGIVCHyaMxZvWAPXfJm9E