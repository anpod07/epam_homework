#!/bin/bash
#gunicorn --user www-data --workers 3 --bind unix:pyapp.sock -m 007 wsgi:app
gunicorn --user www-data --workers 3 --bind 0.0.0.0:8000 -m 007 wsgi:app
