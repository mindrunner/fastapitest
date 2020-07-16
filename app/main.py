import sys
import os
import time
import numpy as np
import pandas as pd
import logging
from fastapi import APIRouter, Depends, FastAPI, Header, HTTPException,Request, Response, status
from pydantic import BaseModel, Field, HttpUrl
from typing import List, Set
import pickle
import itertools
from fastapi.middleware.cors import CORSMiddleware

#=========== CONSTANTS and ERROR Definitions =================
global LANGUAGES
global ERROR_LAN
LANGUAGES = ['de-CH','fr-CH','it-CH','en-US']
ERROR_LAN = HTTPException(status_code=404, detail="language header not one of de-CH, fr-CH, it-CH, en-US")

################## Setup Logger from gunicorn (hack) #########################
import logging

'''
gunicorn_logger = logging.getLogger('gunicorn.error')
root = logging.getLogger()
root.setLevel(logging.INFO)
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
root.addHandler(handler)
'''


################## MAIN App ####################
app = FastAPI(title='test',description='test',version='1.0.0',docs_url=None, redoc_url=None)

origins = [
    "*"
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
	max_age=0
)

################## Main Endpoint ###################
@app.get("/")
async def probe(*, x_start_time_msec: str = Header(None)):
	return {"message": "FastAPI Inconnect",
			"release": "1"
}
