# Create users configuration files
begin
  search('users-files', '*:*').each do |user|
    user.to_hash['files'].each do |file, content|
      file "#{user}/#{file}" do
        path lazy { File.join(node['etc']['passwd'][user.id]['dir'], file) }
        content content.join("\n")
        owner user.id
        group user.id
        action :create_if_missing
      end
    end
  end
rescue Net::HTTPServerException
  Chef::Log.warn('Data bag "users-files" doesn\'t exist')
end
