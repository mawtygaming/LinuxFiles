list = open('list.txt')

perline = list.readline()
while perline:
    print(perline)
    perline = list.readline()
list.close()
