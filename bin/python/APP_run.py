from bin      import EasyPing, IniRead
from urllib   import request
from os       import system
from os       import (
    path as os_path, 
    listdir as DIR,
    remove as os_remove
)

import time


class GKS_Aplication:
    urls         = None
    localData    = None
    dataFolder   = None
    file_format  = None
    ping         = EasyPing.EasyPing().ping

    def __init__(self, url, data, dataFolder, logPath=None, file_format="doc", serverPing = False):

        self.logPath     = logPath
        self.server      = url.split("//")[1].split("/")[0] if serverPing else False
        self.urls        = self._urlsGeneration(url, data)
        self.localData   = self._find_local_data(dataFolder)
        self.dataFolder  = dataFolder
        self.file_format = file_format

    def _urlsGeneration(self, url, diction):
        result = []
        years  = diction['years']
        months = diction['months']

        for year in years:
            for month in months:
                month = month if len(str(month)) > 1 else "0%s" % month
                
                result.append({
                    "url":   url.format(**{"year": year, "month": month}),
                    "date":  "{0}_{1}".format(year, month)
                })

        return result
    
    def _log_append(self, text=""):
            if not self.logPath: return
            if not os_path.exists(os_path.dirname(self.logPath)): 
                raise ResourceWarning("Incorect Log directory")
                return

            with open(self.logPath, "a+") as file: 
                now = time.strftime(time.asctime((time.gmtime(time.time()))))
                text = "\n\t{0}\t{1}".format(text, now)
                file.write(text)
    
    def run(self):
        if self.server:
            if not self.ping(self.server, count=1,  quick=True):
                error = "Server: '%s' is not availability" % self.server
                self._log_append(error)
                raise ConnectionError(error)

        self._downloader()
    
    def _find_local_data(self, dataFolder):
        result = []

        for file in DIR(dataFolder):
            data = file.split(".")[0]
            result.append(data)

        return result

    def _downloader(self):
        '''
            * Проверяем документы которые локально присутствуют;
            * Сравниваем данные с сервером;
            * Если на сервере выложены новые файлы подкачеваем и удаляем старые.

        '''

        step        = ''
        headFoot    = '\n{0}\n'.format('-' * len(self.urls) * 2)
        curentDate  = [19, 0]

        for data in reversed(self.urls):
            date  = data['date']
            iDate = [int(x) for x in date.split("_")]
            url   = data['url']
            fName = "{0}\\{1}.{2}".format(self.dataFolder, date, self.file_format)

            
            #if curentDate[1] < iDate[1] or curentDate[0] != iDate[0]: 
            if not date in self.localData:
                try:
                    request.urlretrieve(url, fName)
                    curentDate = iDate

                except: self._log_append("Document for date:'{0}', not found".format(date))
            
            else: curentDate = iDate

            #elif date in self.localData: os_remove(fName)
             
            # Имитация загрузочной полосы.
            step += '--'; 
            form = '{2}{0}{1}{0}'.format(headFoot, step, '--LOADING--\n')
            
            system('cls')
            print(form)   


if __name__ == "__main__":
    mainFolder = os_path.dirname(os_path.dirname(os_path.dirname(os_path.realpath(__file__))))
    config     = IniRead.INIRead(mainFolder + "\\config.ini").data['mainOptions']

    config['data']      = {"months": [x for x in range(2, 13)], "years":  [18, 19]}
    config['dataFolder'] = mainFolder + "\\data"
    config['logPath']    = mainFolder + "\\logs.txt"
    
    app  = GKS_Aplication(**config)
    app.run()