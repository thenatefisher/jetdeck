module CreateFileHelper

  # create a folder just for this spec
  session_dir = Faker::Internet.domain_word.upcase + "_#{rand(99999)}"
  # create dir structure
  @@tmp_directory = File::join(Rails.root, "tmp")
  Dir::mkdir(@@tmp_directory) if !File::exists?(@@tmp_directory)
  @@tmp_directory = File::join(@@tmp_directory, "fixtures")
  Dir::mkdir(@@tmp_directory) if !File::exists?(@@tmp_directory)
  @@tmp_directory = File::join(@@tmp_directory, session_dir)
  Dir::mkdir(@@tmp_directory) if !File::exists?(@@tmp_directory)  
 
  def create_file(extension="pdf", size=50)
    begin
      file_name = Faker::Internet.domain_word + ".#{extension}"
      file_path = File::join(@@tmp_directory, file_name)    
      `dd if=/dev/zero of=#{file_path} bs=#{size} count=1`
      file_handler = File.open(file_path)
    rescue => exception
      raise exception
    end
    return file_handler
  end

  def create_image_file(extension="png", size=500000)
    
    begin
      file_name = Faker::Internet.domain_word + ".#{extension}"
      file_path = File::join(@@tmp_directory, file_name) 

      favicon = File::join(Rails.root, "spec", "fixtures", "favicon.png")
      `dd if=/dev/zero of=#{file_path} bs=#{size} count=1`
      `dd if=#{favicon} of=#{file_path} conv=notrunc` 

      file_handler = File.open(file_path)
    rescue => exception
      raise exception
    end
    return file_handler    
 
  end

end
