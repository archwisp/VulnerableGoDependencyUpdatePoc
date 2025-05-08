#vim: ts=4:sw=4:et
import sys, os, json
from helpers import go_mod_file, vulncheck_file

if len(sys.argv) != 3:
    print("Usage: %s <mod-file> <vulncheck-file>" % (os.path.basename(sys.argv[0])))
    sys.exit(0)

mod_file_name = sys.argv[1]
vulncheck_file_name = sys.argv[2]

if not os.path.exists(mod_file_name):
    print("Error: Module file does not exist. Quitting.")
    sys.exit(0)

if not os.path.exists(vulncheck_file_name):
    print("Error: Vulncheck file does not exist. Quitting.")
    sys.exit(0)

print("Processing vulncheck file: %s" % vulncheck_file_name)
vulncheck = vulncheck_file.VulncheckFile(vulncheck_file_name)
vulns = vulncheck.parse_vulns()

print("Processing module file: %s" % mod_file_name)
mod = go_mod_file.GoModFile(mod_file_name)
mod.update_vulns(vulns)

