require 'resolv'

filename = 'rbls.txt'
newfilename = 'rbladdresses.txt'

addresses = {}

File.open(filename).each do |line|
  begin
   ip = Resolv.getaddress(line.chomp)
 rescue
   puts "Unable to resolve #{line.chomp}"
 else
   puts ip
   addresses[line.chomp] = ip
 end
end

File.open(newfilename, 'w') do |file|
  addresses.each do |h, k|
    file.write("#{h},#{k}\n")
  end
end

puts "file closed."
