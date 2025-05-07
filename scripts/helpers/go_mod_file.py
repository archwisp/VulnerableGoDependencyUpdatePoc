#vim: ts=4:sw=4:et
class GoModFile:
    file_name = "" 
    file_contents = ""
    vulns = []

    def __init__(self, file_name):
        self.file_name = file_name

    def read(self):
       self.file_contents = open(self.file_name)
    
    def write(self):
       file_handle = open(self.file_name, "r")
       file_handle.write(self.file_contents.join("\n"))
       file_handle.close()

    def update_vulns(self, vulns):
        self.read()
        line_number = 0

        for line in self.file_contents:
            for vuln in vulns:
                if vuln["lib"] in line and vuln["vuln_version"] in line:
                    print("Found match for %s on line number %s" % (vuln["lib"], line_number))
                    print("Updating version from %s to %s" % (vuln["vuln_version"], vuln["fix_version"]))
                    line.replace(vuln["vuln_version"], vuln["fix_version"])

            line_number += 1
