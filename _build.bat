@ECHO OFF

CD C:\Users\David\Documents\OneDrive\Documents\My Documents\GitHub\churches\_ruby

ruby generate_notebook.rb

CD C:\Users\David\Documents\OneDrive\Documents\My Documents\GitHub\churches

jekyll build --verbose --config _config.yml

PAUSE
