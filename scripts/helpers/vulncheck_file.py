#vim: ts=4:sw=4:et
class VulncheckFile:
    file_name = "" 
    file_contents = ""
    vulns = []

    def __init__(self, file_name):
        self.file_name = file_name

    def read(self):
       file_handle = open(self.file_name, "r")
       self.file_contents = file_handle.read().split("\n")
       file_handle.close()

    def parse_vulns(self):
        self.read()
        found = False
        line_number = 0

        for line in self.file_contents:
            if (line.startswith("Vulnerability")):
                found = True
                # print("Found %s on line %s" % (line.strip(), line_number))
                vuln = {"lib": "", "vuln_version": "", "fix_version": "" }
            
            if found == True: 
                if line.strip() == "":
                    found = False
                    # print("End of vulnerability on line %s" % (line_number))
       
                if (line.strip().startswith("Found")):
                    vuln_str = line.strip().split(':')[1].strip()
                    vuln["lib"] = vuln_str.split("@")[0]
                    vuln["vuln_version"] = vuln_str.split("@")[1]
                    print("Vulnerability is in %s on line %s" % (vuln_str, line_number))
            
                if (line.strip().startswith("Fixed")):
                    fix_str = line.strip().split(':')[1].strip()
                    vuln["fix_version"] = fix_str.split("@")[1]
                    print("Fix is in %s on line %s" % (fix_str, line_number))
                    self.vulns.append(vuln)
                    found = False
          
            line_number += 1
        
        return self.vulns
