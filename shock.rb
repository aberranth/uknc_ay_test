data = File.binread('ShockMegaDemo02.ay')
offset = 0x8000 - 0x70
header ="; "
header += "vim: set filetype=asmpdp11 tabstop=8 expandtab shiftwidth=4 autoindent :\n"
header += "\t.RADIX\t16\n"

File.open('shockp.mac', 'w') do |f|
  # pointers 0x8000..0xA7FE
  first = 0x8000 - offset
  last  = 0xA7FF - offset
  pointers = data[first..last].unpack('S*')
  puts pointers.max.to_s(16)
  f.puts header
  f.puts 'offsets:'
  pointers.each.with_index do |word, i|
    if i % 8 == 0
      # f.print "l#{(0x8000 + i).to_s(16).upcase.rjust(4, '0')}:\t"
      f.print "\t"
      f.print ".WORD\t"
    end
    f.print (word - 0xA800).to_s(16).rjust(5, '0')
    if i % 8 == 7
      f.puts
    else
      f.print ','
    end
  end
end

File.open('shockd.mac', 'w') do |f|
  # data 0xA800..0xD867
  first = 0xA800 - offset
  last  = 0xD867 - offset
  arrays = data[first..last].unpack('C*')
  f.puts header
  f.puts 'AYdata:'
  arrays.each.with_index do |byte, i|
    if i % 16 == 0
      # f.print "l#{(0xA800 + i).to_s(16).upcase.rjust(4, '0')}:\t"
      f.print "\t"
      f.print ".BYTE\t"
    end
    f.print byte.to_s(16).rjust(3, '0')
    if i % 16 == 15
      f.puts
    else
      f.print ','
    end
  end
end
