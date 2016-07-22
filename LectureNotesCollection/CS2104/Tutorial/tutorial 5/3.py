def dicToList(dic):
    list = []
    for key,element in dic.items():
        list.append(key)
        list.append(element)
    return list

a = dicToList({'yy':123,'cz':312})

