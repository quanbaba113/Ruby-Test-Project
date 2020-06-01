require_relative './../environment'

module AST

  class Suite
    include Environment

    DEFAULT_DRIVER = :webkit
    DEFAULT_SELECTOR = :css
    DEFAULT_WAIT_TIME = 60

    attr_accessor :browser, :stack,
                  :role, :host,
                  :default_driver, :default_selector,
                  :default_wait_time

    def self.configure
      suite = self.new
      yield(suite)
      suite.bootstrap_capybara
      suite
    end

    def bootstrap_capybara
      Capybara.app_host = self.host
      Capybara.default_driver = self.default_driver || DEFAULT_DRIVER
      Capybara.default_selector = self.default_selector || DEFAULT_SELECTOR
      Capybara.default_wait_time = self.default_wait_time || DEFAULT_WAIT_TIME
      send(:"configure_#{browser}")
    end

    private

    def configure_webkit
      Capybara::Webkit.configure do |config|
        #config.debug = true

        config.allow_url stack_url('pie1')
        config.allow_url stack_url('test1')
        config.allow_url stack_url('stage1')
        config.allow_url stack_url('https://lastpass.com/generatepassword.php')
        config.allow_url stack_url('https://agena-pie1.services.hpconnectedpie.com/admin')
        config.allow_url stack_url('https://www.mohmal.com/pt/')
        config.allow_url stack_url('https://mailinator.com/')

        config.ignore_ssl_errors
        config.skip_image_loading
      end

      Capybara.javascript_driver = :webkit_ignore_ssl
    end

    def configure_firefox
      Capybara.register_driver :firefox do |app|
        Capybara::Selenium::Driver.new(app, :browser => :firefox)
      end
      Capybara.default_driver = :firefox
    end

    def configure_chrome
      Capybara.register_driver :selenium_chrome do |app|
        Capybara::Selenium::Driver.new(app, :browser => :chrome)
      end
      Capybara.default_driver = :selenium_chrome
    end

    def configure_opera
      Capybara.register_driver :opera do |app|
        Capybara::Selenium::Driver.new(app, :browser => :opera)
      end
      Capybara.default_driver = :opera
    end

    def configure_ie9
      configure_ie
    end

    def configure_ie10
      configure_ie
    end

    def configure_ie11
      configure_ie
    end

    def configure_ie
      Capybara.app_host = "http://16.127.75.50:3000/ast/"
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = ENV['CLIENT_TIMEOUT'] ? ENV['CLIENT_TIMEOUT'].to_i : 60
      capabilities = Selenium::WebDriver::Remote::Capabilities.new
      capabilities[:introduce_flakiness_by_ignoring_security_domains] = true
      capabilities[:javascript_enabled] = true
      capabilities[:css_selectors_enabled] = true
      capabilities[:ignore_protected_mode_settings] = true
      capabilities[:internet_explorer] = true
      current_url = 'http://172.16.109.123:4444/wd/hub/'

      if browser == 'ie10'
        current_url = 'http://172.16.103.254:4444/wd/hub/'
      elsif browser == 'ie11'
        current_url = 'http://172.16.109.56:4444/wd/hub/'
      end

      Capybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(app,
                                       :browser => :remote,
                                       :url => current_url,
                                       :http_client => client,
                                       :desired_capabilities => capabilities)
      end
    end

  end

end
