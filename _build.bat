@ECHO OFF

CD C:\Users\David\Documents\Google Drive\Notebook\3. Churches\GitHub\churches\_ruby

ruby generate_notebook.rb

CD C:\Users\David\Documents\Google Drive\Notebook\3. Churches\GitHub\churches

jekyll build --verbose --config _config.yml

PAUSE
