provides :ourdata

property :line, String, name_property: true

action :create do
  line = new_resource.line
  file_path = '/etc/hosts'

  ruby_block "append_line_to_#{file_path}" do
    block do
      content = ::File.read(file_path)
      unless content.include?(line)
        ::File.write(file_path, content + "\n" + line)
      end
    end
  end
end
