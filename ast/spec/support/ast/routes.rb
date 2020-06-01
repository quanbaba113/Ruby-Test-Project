module AST

  class Router

    def self.url_from_path(path)
      "#{ENV['APP_HOST']}/ast/#{path}"
    end

    def self.login_url
      url_from_path('auth/users/sign_in')
    end

  end

end
