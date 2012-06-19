#The general system conversion from date to the external date used by BDP
#Converted from Y to y by MHO
#Are we guaranteed to have 2 digits for each?
def d(date)
  if date == nil
    return ''
  end
  date.strftime('%Y-%m-%d')
end

def ds(date)
  if date == nil
    return ''
  end
  date.strftime('%m-%d-%y')
end
