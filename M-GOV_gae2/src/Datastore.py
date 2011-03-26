
from google.appengine.ext import db

class Case(db.Model):
    adress = db.StringProperty()
    h_admit_name = db.StringProperty()
    h_admiv_name = db.StringProperty()
    h_summary = db.StringProperty()
    
    coordx = db.FloatProperty()
    coordy = db.FloatProperty()
    
    caseType = db.IntegerProperty()
    caseSource = db.IntegerProperty()
    status = db.IntegerProperty()
    
    name = db.StringProperty()
    email = db.EmailProperty()
    
    receive = db.StringProperty()
    date = db.StringProperty()
    photo = db.StringListProperty()
    
    orther = db.TextProperty()
    
    
class Facebook_Case(db.Model):
    caseid = db.StringProperty()