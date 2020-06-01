class Credential

  def self.username
    @username ||= YAML.load(File.read(YML_PATH))['credentials']['username']
  end

  def self.password
    @password ||= YAML.load(File.read(YML_PATH))['credentials']['password']
  end

  private

  YML_PATH = File.dirname(__FILE__) + '/credentials.yml'
end