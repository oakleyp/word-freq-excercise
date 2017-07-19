class Wordfreq
  STOP_WORDS = ['a', 'an', 'and', 'are', 'as', 'at', 'be', 'by', 'for', 'from',
    'has', 'he', 'i', 'in', 'is', 'it', 'its', 'of', 'on', 'that', 'the', 'to',
    'were', 'will', 'with']

  def initialize(filename)
    @filename = filename
    
    #Stores file as array of lines, lowercase with punctuation removed
    @file_lines = File.open(filename).map {|line| line.downcase .gsub /([,:;!.])+/, ""}
    @file_lines = @file_lines.map{|line| line.gsub /(--)+/, " "}
  end

  def frequency(word)
    freq = 0
    @file_lines.map {|line| freq += line.scan(/(\s#{word}\s)+/).length}
    freq
  end

  def frequencies
    result = Hash.new()
    
    #Put every word in file into array
    all_words = []
    @file_lines.each do |line| 
      line.scan(/(\w+)+/).map {|word| all_words.push(word[0].to_s)}
    end

    #remove stop words
    all_words -= STOP_WORDS

    all_words.each do |word|
      if(result[word].nil?)
        result[word] = 1
      else 
        result[word] = result[word].to_i + 1
      end
    end

    result

  end

  def top_words(number)
    result = frequencies.sort_by {|k, v| v}.reverse
    result.take(number)
  end

  def print_report
    top10 = top_words(10)
    result = top10.each do |key, value|
      starstr = "*" * value.to_i
      printf("%7s | %1d %1s \n", key, value, starstr)
    end
  end
end

if __FILE__ == $0
  filename = ARGV[0]
  if filename
    full_filename = File.absolute_path(filename)
    if File.exists?(full_filename)
      wf = Wordfreq.new(full_filename)
      
      ##DEBUG
      wf.top_words(8)
      wf.frequencies
      wf.print_report
    else
      puts "#{filename} does not exist!"
    end
  else
    puts "Please give a filename as an argument."
  end
end
