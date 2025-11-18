def modifyList(t):
  t.append(5)

t = [1,2,3]
alias = t
t.append(4)
modifyList(t)
print(alias)
print(t)