def createDic(list):
    X = {}
    for i in range(0,round(len(list)/2)):
        X[list[2*i]] = list[2*i+1]
    return X

Dic = createDic(['songyy',2,"lalala",3])

