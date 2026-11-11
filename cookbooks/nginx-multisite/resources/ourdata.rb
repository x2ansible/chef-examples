provides :ourdata

property :line, String, name_property: true

action :create do
  line = new_resource.line
  file_path = '/opt/ourdata.txt'
  match_pattern = '^mode='

  ruby_block "update_line_in_#{file_path}" do
    block do
      raise "ourdata: file not found: #{file_path}" unless ::File.exist?(file_path)

      content = ::File.read(file_path)
      regex = /#{match_pattern}/

      new_content = content.split("\n").map { |l| l.match?(regex) ? line : l }.join("\n")

      if new_content != content
        ::File.write(file_path, new_content)
      end
    end
  end
end
