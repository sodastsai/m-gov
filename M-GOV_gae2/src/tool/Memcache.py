# Django 1.2
from google.appengine.dist import use_library
use_library('django', '1.2')

from google.appengine.ext import webapp
from google.appengine.api import memcache
from django.utils import simplejson as json

from Constants import errorMsg

## Memecahe flush tool
class MemcacheHandler(webapp.RequestHandler):
    def get(self):
        if self.request.get("flush")=="true":
            memcache.flush_all() #@UndefinedVariable
            resultDict = {"result": 0}
            self.response.out.write(json.dumps(resultDict))
        else:
            self.response.out.write(errorMsg(202))