# Create users configuration files
begin
  search('users-files', '*:*').each do |user|
    user.to_hash['files'].each do |file, content|
      file "#{user.id}/#{file}" do
        path lazy { File.join(node['etc']['passwd'][user.id]['dir'], file) }
        content content.join("\n") << "\n"
        owner user.id
        group user.id
        action :create_if_missing
      end
    end
  end
rescue Net::HTTPServerException
  Chef::Log.warn('Data bag "users-files" doesn\'t exist')
end
