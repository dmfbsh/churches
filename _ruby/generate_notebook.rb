require 'sqlite3'
require 'fileutils'

puts "Starting: generate_notebook"

Joplin = "C:/Users/small/.config/joplin-desktop/database.sqlite"
ResFdr = "C:/Users/small/.config/joplin-desktop/resources"
TempDB = "C:/Users/David/Documents/OneDrive/Documents/My Documents/3. Shropshire/database/temp/warehouse.db"
SQLite = "C:/command/sqlite3.exe"
DumpFl = "C:/Users/David/Documents/OneDrive/Documents/My Documents/3. Shropshire/database/temp/warehouse.sql"

cmd = SQLite + " \"" + TempDB + "\" " + "\"DROP TABLE IF EXISTS resources;\"" + " .exit"
system(cmd)

puts 'Dumping resources table from Joplin database...'
txt = ".output \"" + DumpFl + "\"\n"\
      ".dump resources\n"\
      ".output\n"\
      ".open \"" + TempDB + "\"\n"\
      ".read \"" + DumpFl + "\"\n"
File.write(__dir__ + "/Create_Temp_Data.txt", txt)
cmd = SQLite + " \"" + Joplin + "\" < \"" + __dir__ + "/Create_Temp_Data.txt\""
system(cmd)
puts '...done.'

File.delete(DumpFl) if File.exist?(DumpFl)
File.delete(__dir__ + "/Create_Temp_Data.txt") if File.exist?(__dir__ + "/Create_Temp_Data.txt")

db = SQLite3::Database.open TempDB

notes = db.query "SELECT title, body FROM notes n WHERE parent_id = 'd220005a6ebb4f319646651b56783656' ORDER BY title"

notes.each { |note|
  puts "..." + note[0]
  dstf = "../3churches-notebook/" + note[0] + ".md"
  dsth = File.open(dstf, "w:UTF-8")
  dsth.write("---\n")
  dsth.write("layout: page\n")
  dsth.write("---\n")
  dsth.write("\n")
  body = note[1]
  resources = body.scan(/\(:[^)]*/)
  resources.each { |resource|
    resid = resource.gsub("(:/", "")
    resfs = db.query "SELECT id, title FROM resources WHERE id = '" + resid + "'"
    resfs.each { |resfl|
      puts resfl[0] + ", " + resfl[1]
      FileUtils.cp ResFdr + "/" + resfl[0] + ".jpg", "../3churches-notebook/attachments/" + resfl[1], :verbose => true
    }
  }
  body = body.gsub(/\]\(:[^)]*/, "")
  body = body.gsub(/!\[/, "![](attachments/")
  dsth.write(body)
  dsth.close unless dsth.nil?
}

puts "Done: generate_notebook"
