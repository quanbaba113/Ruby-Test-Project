require 'rspec'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'rspec/expectations'
require 'faraday'
require 'nokogiri'
require 'logger'
require 'byebug'
require 'date'

client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 300

# Firefox Profile with proxy settings for Windows 10 node
PROXY = 'web-proxy.corp.hp.com:8088'
#PROXY = 'web-proxy.austin.hpicorp.net:8080'

$profile = Selenium::WebDriver::Firefox::Profile.new
#new(File.dirname(__FILE__) + '/../../../firefox_profile/pie1')''
$profile.proxy = Selenium::WebDriver::Proxy.new(
    :http => PROXY,
    :ftp  => PROXY,
    :ssl  => PROXY
)
$profile.secure_ssl = false
$profile.assume_untrusted_certificate_issuer = false

caps = Selenium::WebDriver::Remote::Capabilities.firefox
caps[:unexpectedAlertBehaviour] = "accept"

Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => $profile, :http_client => client, :desired_capabilities => caps)
end

Capybara.default_driver = :firefox

Capybara.javascript_driver = :selenium

Capybara.run_server = false

Capybara.default_selector = :css

Capybara.default_max_wait_time = 30

World(Capybara::DSL, Capybara::RSpecMatchers)

if ENV.key?('AGENA_CLEAR_LOGS') and File.file?("output.out")
  File.delete("output.out")
end