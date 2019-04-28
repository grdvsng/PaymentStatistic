''' INIread
    
        description: easy module for read ini files.
        classes: 
            INIRead - main class.

        author: Trishkin Sergey

'''

class INIRead:
    commentSymbals = [
        ';',
        '#'
    ]

    def __init__(self, filePath):
        ''' Module __init__ class INIRead.

                parameters:
                    filePath - (str) - ini file to parse.

            desc:
                module parse file and append data like ini in class atribute 'data'.

        '''

        self.data = self._parse(filePath)
    
    def _parse(self, filePath):
        data   = {}
        sector = None

        with open(filePath, 'r') as file:
                line = str(file.readline())
                
                while line:
                    for symbol in line:

                        if symbol == '[': 
                            sector = str(line.split("[")[1]).split("]")[0]
                            data[sector] = {}
                        
                        elif symbol not in self.commentSymbals: 
                            values = str(line.split(";")[0]).split("=")
                            data[sector][values[0].strip()] = values[1].strip()
                        break

                    line = file.readline()

        return data