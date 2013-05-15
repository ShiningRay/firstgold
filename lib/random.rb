# -*- encoding : utf-8 -*-
module Kernel
# misc method for rand

def roll(a,b)
  return a if a==b
  rand(b-a+1) + a
end



#the mDn format in DnD
def dice(facets, num=1)
  t=0
  num.times{t+=roll(1, facets)}
  t
end

#simplified 1Dn
def d(f)
  roll(1, f)
end
end
