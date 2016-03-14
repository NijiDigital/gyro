class File

  def self.find_xcdatamodel(dir)
    Dir.chdir(dir) do
      files = Dir.glob('*.xcdatamodel')
      files.first.nil? ? nil : File.expand_path(files.first, dir)
    end
  end

  def self.write_file_with_name(dir, name_file, content)
    file_path = File.expand_path(name_file, dir)
    File.write(file_path, content)
  end

end
