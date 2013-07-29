import os
import sys
import re

def usage(argv):
  print "USAGE: %s regex_match regex_replace [directory]"%argv[0];

def replace(file_name, local_include, global_include):
  f = open(file_name)
  file_text = f.read()
  file_out_text = re.sub("include \"" + local_include, "include \"" + global_include, file_text)
  f.close()
  #print(file_out_text)
  with open(file_name, 'w') as f_out:
    f_out.write(file_out_text);

def handle_dir(directory, local_include, global_include):
  directory_list = os.listdir(directory)

  for dir_object in directory_list:
    full_path = os.path.realpath(os.path.join(directory, dir_object))
    print("%s"%full_path)
    if (os.path.isdir(full_path)):
      print("handle as dir")
      handle_dir(full_path, local_include, global_include)
    elif (os.path.isfile(full_path)):
      print("handle as file")
      replace(full_path, local_include, global_include)

if (__name__ == '__main__'):
  if (len(sys.argv) == 3):
    handle_dir('.', sys.argv[1], sys.argv[2])
  elif (len(sys.argv) == 4):
    handle_dir(sys.argv[3], sys.argv[1], sys.argv[2])
  else:
    usage(sys.argv)
    sys.exit(1)



