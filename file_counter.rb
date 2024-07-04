require 'digest'

def calculate_file_hash(filepath)
  sha256 = Digest::SHA256.new
  File.open(filepath, 'rb') do |file|
    buffer = ''
    sha256.update(buffer) while file.read(8192, buffer)
  end
  sha256.hexdigest
end

def count_duplicate_files(directory_path)
  file_hash_count = Hash.new(0)
  file_hash_content = {}

  Dir.glob("#{directory_path}/**/*").each do |filepath|
    next unless File.file?(filepath)

    file_hash = calculate_file_hash(filepath)
    file_content = File.read(filepath)

    file_hash_count[file_hash] += 1
    file_hash_content[file_hash] = file_content
  end

  max_count = file_hash_count.values.max
  most_common_hash = file_hash_count.key(max_count)
  most_common_content = file_hash_content[most_common_hash]

  puts "#{most_common_content.strip} #{max_count}"
end

if __FILE__ == $0
  if ARGV.empty?
    puts "Usage: ruby script.rb <directory_path>"
  else
    directory_path = ARGV[0]
    count_duplicate_files(directory_path)
  end
end