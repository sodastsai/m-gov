# Django 1.2
from google.appengine.dist import use_library
use_library('django', '1.2')

from django.utils import simplejson as json

## Error code dictionary
errorDict = {
             100: "Google App Engine Error.",
             101: "Google App Engine Timeout.",
             
             200: "Service Not Found.",
             201: "REST path is error.",
             202: "GET argument is error.",
             
             300: "Fetch result is empty.",
             }

##
# Error message generator
#
# Argument
# - errorCode: the error code
# - reason: (optional) the reason of this error
#
# Return
# - A json string which represent a dict with error code and reason.
#
def errorMsg(errorCode, reason=""):
    result = {"error":int(errorCode), "reason": (errorDict[errorCode]+" "+reason).strip()}
    return json.dumps(result, sort_keys=True)