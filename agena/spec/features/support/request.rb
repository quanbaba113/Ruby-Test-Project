module Request

  GEMINI_URLS_DOMAIN = {
      test1: 'instantink-test1.hpconnectedtest.com',
      pie1: 'instantink-pie1.hpconnectedpie.com',
      stage1: 'instantink-stage1.hpconnectedstage.com',
      prod: 'instantink.hpconnected.com'
  }

  GEMINI_MAP_COUNTRY_LANGUAGE = {
      US: "en",
      CA: "en",
      CAF: "fr",
      UK: "en",
      DE: "de",
      ES: "es",
      FR: "fr",
  }

  AGENA_URLS = {
      test1: 'https://agena-test1.services.hpconnectedtest.com/',
      stage1: 'https://agena-stage1.services.hpconnectedstage.com/',
      pie1: 'https://agena-pie1.services.hpconnectedpie.com/',
      localhost: ''
  }

  def gemini_url(stack, country, app)
    login_credentials = app == "gemini_login" ? "gemini:inksub2@" : ""
    url = "https://" + login_credentials + GEMINI_URLS_DOMAIN[stack.strip.to_sym]
    if GEMINI_MAP_COUNTRY_LANGUAGE.key?(country.strip.to_sym)
      url_country = country.strip == "CAF" ? "ca" : country.strip.downcase
      url += "/" + url_country + "/" + GEMINI_MAP_COUNTRY_LANGUAGE[country.strip.to_sym] + "/r"
    end
    url
  end

  def agena_stack_url(stack)
    AGENA_URLS[stack.strip.to_sym]
  end

  def puc(stack)
    case stack.strip
      when 'pie1'
        'NWZiNDc4NGJhYTQ4NDY4MjliMzhkYzJjNzkxMmE5NjE4NWNmZGFkMWRiZGFkNTA3MjU1Nzg1ZGFkNjdlNzdjNToxMTI3YmQ3YTZlNzYxMDJkOTJiMDEyMzEzc2ljcHNmMjpJbmsgU3Vic2NyaXB0aW9uIDIuMDoxNDc0NjYwMDE3NDkyOjE0ODE4NjAwMTc0OTI6MjY6ZmFsc2U6Z1RPTERTM0xjRlFUNzIwVitKdnBnUm03SzJKcC83ekNYN0RxMVZJN2VobWlmaUtuS0tFbkZ2Wlh4UDZnVk95Nk5ZSUJEZlJ3TmNJaFo2ZmRXNWEvZTllemU3QXZiMjNFbElvNEdPakRtWm1QVENKeitQakIwdllMd1MvQ3F3dmFPVXlXMFMvSmdkdjRmMDZ5V0l4QUR5c2ZjcG1pdzZVTUJxOUdsY0RadTQ5RUxneVI5QS8wTmFpUFJXWUVzbjZxVnlONXRCZnQvdlNHU0lWSHo3aTAyT2xjYkQ0dGM4cVNHalQ1L21wdmlJdDdBZzc1WWRDS3VpSXpsNlJaYldmZTVpdWZHbFBBMkFiVWFVWjZmdkZBb1Zxa1BPVDEzVmc4aHo4S1NqLy91dzNqNUxBaHR3Ym1scG9nNnlqNXo0VWF6VVV6dk4rZ2I3c0pRWFFQSEFDVVV3PT0='
      when 'test1'
        'OGVlMTU3ZGNiYjliYTJkNTM4ZmZmOTRmODcxMzBmMzQ0ZWJjMDk1ZDhhNmVmM2Y0OWE5N2VjYjBkOGY0ODljZDoxMTI3YmQ3YTZlNzYxMDJkOTJiMDEyMzEzc2ljcHNmMjpJbmsgU3Vic2NyaXB0aW9uIDIuMDoxNDc0NjU2MzUyOTQyOjE0ODE4NTYzNTI5NDI6MjY6ZmFsc2U6ZXB3V3Bralk3K2pVVDkxMCtJOE5CQWp4N2o2NjZ5VUhXNDU5NytQdEx2RFZXS2VzRklNbzdkcFFoc3c1aENwMWVDYU1yajd0c1c1MWRMSExTSlhIV0NxakFsaW9ld1lYVEJsdW84VytFc2FVV0ZITHVWOFFHdkd1c1V1YlBWOVdSY0FUdjVJYXFoMHBORHhHMXRRb1FocHBjTCs1a1VqTkRnUlJEN0lsYnFKQUxwNDdvU05maU8rRlZTQWZhM2JXb0xuSGZ4TnV2dEpzQXE3UXh2QkNHVFJ5SHZ2SGNKNlpDRG5rN2hrR3BSa2trdU9VNEFqajBzZ1VuVlNmempMWmpPdm9aM2NXdVlPZ2VxRlhxODEzQ3E1V3BiUy9JWHNIeDI4SFRva3dhV094elVMc2lPekpFMGZySmRXblVxd1NEUXgrZ2xDakFGVWtONVY4Y1h0ZlVRPT0='
      when 'stage1'
        'N2VmMTk4ZmRmNzZkYzFiNWUwYTE2ZjhiYzEyNjQ2ODg3MTIzMDBlZTRiZDM2Y2IwOTdhNjI4YzI1NmE2Njc4YzoxMTI3YmQ3YTZlNzYxMDJkOTJiMDEyMzEzc2ljcHNmMjpJbmsgU3Vic2NyaXB0aW9uIDIuMDoxNDc0NjYxNDgxNTkyOjE0ODE4NjE0ODE1OTI6MjY6ZmFsc2U6SDE3Y0ZUMXdVOEFCd1ZqSzA3RUg4VitDVVNEaERPbEQxV1d0MGJ1M0dRbzFEY1V0MkU3bjZsbzU5VnNDVWFDaHVzWFIwaFNVc3VQSnlnNVhGSFp3NDFQRzdsVVYvQkV6VjRZVmp1ZWRydFU0MkdiS0lxODZjU1lXeG1ZMGwxTThGaFhocE1MZ29OcndWNEJ0a01BTFRRbjN0ejV6Tkc2NFV1NElITERYUngyMDFqNitSOVMxMFU2OFQ0L1YzOE1WSzdhL3orVmdna3BLSTlYMzRQQ0xsUGZPR3FKN0JrYjhwaXRSM3ZCSnNoVmwzU2ZjRWJzWEprWnM4cGZtalNRODRRRlBkSTBkakVvQVNMMjlYYkQ4QjN2bEc0SDAwSmpXUXhZZDhrWTUrOVdKZVdnQUNVV2RsS21IWVRGdWNzZmM0RW42aUlhWVZwSXBEYTVPdUNQR0pnPT0='
      else
        nil
    end
  end

  [:get, :patch, :post, :put, :delete].each do |verb|
    define_method(verb) do |options = {}|
      stack = options.key?(:stack) ? options[:stack] : "test1"
      endpoint = options.key?(:endpoint) ? options[:endpoint] : "/"
      v2 = options.key?(:v2) ? options[:v2] : false
      payload = options.key?(:payload) ? options[:payload] : {}
      verbose = options.key?(:verbose) ? options[:verbose] : false
      headers = options.key?(:headers) ? options[:headers] : {}
      url = agena_stack_url(stack) + endpoint
      if verbose
        puts url
      end
      pending "Should not run on this stack" if ENV.key?('AGENA_STACKS') and not ENV['AGENA_STACKS'].split(",").include?(stack)
      execute_request(verb, url, payload, make_headers(headers, v2, stack))
    end
  end

  def sanitize(string)
    options = {
        invalid: :replace,
        undef: :replace,
        replace: ''
    }

    utf8_string = string.force_encoding('UTF-8')
    utf8_string.encode(Encoding.find('UTF-8'), options)
  end

  def make_headers(headers, v2, stack)
    token = puc(stack)
    default_headers = {
        'Authorization' => "Bearer #{token}",
        'Accept' => 'application/json'
    }

    headers_custom = default_headers.merge(headers)
    headers_custom['Accept'] = 'application/vnd.agena+json;version=2' if v2
    headers_custom
  end

  def execute_request(method, url, payload, headers)
    faraday_execute_request(method: method, url: URI.escape(url), payload: payload, headers: headers)
  end

  def faraday_execute_request(options = {})
    connection = Faraday.new(:url => options[:url], :ssl => {:verify => false}) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      #faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    body = (options[:payload].is_a? Hash) ? options[:payload].to_json : options[:payload]

    connection.send(options[:method]) do |req|
      req.options[:timeout] = 600
      req.headers = options[:headers]
      req.body = body unless body.empty?
    end
  end


end
