require 'logger'

module Environment

  DEFAULT_BROWSER = 'webkit'
  DEFAULT_STACK = 'pie1'
  DEFAULT_ROLE = 'admin'
  STACKS = {
      test1: {
          admin: 'janesmith_adm_hp@mailinator.com',
          operations: 'janesmith_operations_hp@mailinator.com',
          agent_lead: 'janesmith_agent_lead@mailinator.com',
          agent: 'janesmith_agent_hp@mailinator.com'
      },
      stage1: {
          admin: 'johnsmith_stg_adm_hp@mailinator.com',
          operations: 'johnsmith_stg_operations_hp@mailinator.com',
          agent_lead: 'johnsmith_stg_agent_lead@mailinator.com',
          agent: 'johnsmith_stg_agent_hp@mailinator.com'
      },
      pie1: {
          admin: 'ludmila.arruda@hp.com',
          operations: 'johnsmith_operations_hp@mailinator.com',
          agent_lead: 'johnsmith_agent_lead@mailinator.com',
          agent: 'johnsmith_agent_hp@mailinator.com'
      },
      localhost: {
          admin: 'johnsmith_adm_hp@mailinator.com',
          operations: 'johnsmith_operations_hp@mailinator.com',
          agent_lead: 'johnsmith_agent_lead@mailinator.com',
          agent: 'johnsmith_agent_hp@mailinator.com'
      }
  }

  $logger = Logger.new(STDOUT)

  def setup_ast_environment
    @password = 'Passw0rd'
    @role = ENV['AST_TEST_ROLE'] || DEFAULT_ROLE
    @env = ENV['AST_STACK'] || DEFAULT_STACK
    @user = STACKS[@env.to_sym][@role.to_sym]
    @invalid_user = 'test@gmail.com'
    @invalid_password = '12345678'
    case @env
      when 'test1'
        @operations = 'janesmith_operations_hp@mailinator.com'
        @printer = 'test.gemini.p+v1201@gmail.com'
        @printer_customer_account = ''
        @printer_customer_account_return = ''
        @printer_return = 'otto tester'
        @promo_expired = 'EXPIREDFREE4APPS'
        @promo_uk = 'integrationtestsuk0'
        @promo_us = 'integrationtestsus0'
        @promo_fr = 'integrationtestsfr0'
        @promo_de = 'integrationtestsde0'
        @promo_it = 'integrationtestsit0'
        @promo_es = 'integrationtestses0'
        @promo_ca = 'integrationtestsca0'
        @key_activated = 'BHHV-TKHM-D3RB-99FA'
        @key_redeemed = 'BVV9-PGVT-RDZZ-TNAR'
        @key_deactivated = 'BFFS-KMF7-VMR9-WB7A'
        @account = '1499856982'
        @printerserial = 'CN33H1005905XT'
      when 'pie1'
        @operations = 'johnsmith_operations_hp@mailinator.com'
        @printer = 'pietra_smith_test_1807@mailinator.com'
        @printer_return = 'Pietra Smith'
        @promo_expired = 'mustang'
        @promo_uk = 'integrationtestsuk'
        @promo_us = 'integrationtestsus'
        @promo_fr = 'integrationtestsfr'
        @promo_de = 'integrationtestsde'
        @promo_it = 'integrationtestsit'
        @promo_es = 'integrationtestses'
        @promo_ca = 'integrationtestsca'
        @key_activated = 'BXXZ-MFXH-KMRD-Y799'
        @key_redeemed = 'BAAB-GZAV-3GMK-WMNX'
        @key_deactivated = 'BHHV-TRHM-DTX4-WYSB'
        @account_number = '5217625236'
        @account = '5482913358'
        @printerserial = 'TH46C151640650'
        @url_gemini = 'https://instantink-pie1.hpconnectedpie.com/rails_admin'
        @url_agena = 'https://agena-pie1.services.hpconnectedpie.com/admin'
        @resque_url = 'https://instantink-pie1.hpconnectedpie.com/resque/overview'
      when 'stage1'
        @operations = 'johnsmith_stg_operations_hp@mailinator.com'
        @printer = 'instant-ink-stage-br@hp.com'
        @printer_customer_account = 'johnsmith_user_es_stage1@mailinator.com'
        @printer_customer_account_return = 'John Smith'
        @printer_return = 'Instant Ink BR'
        @promo_expired = 'EXPIRED'
        @promo_uk = 'integrationtestsuk2'
        @promo_us = 'integrationtestsus2'
        @promo_fr = 'integrationtestsfr2'
        @promo_de = 'integrationtestsde2'
        @promo_it = 'integrationtestsit2'
        @promo_es = 'integrationtestses2'
        @promo_ca = 'integrationtestsca2'
        @key_activated = 'BTTM-D7TT-TTGM-FMD4'
        @key_redeemed = 'BFFS-KTFF-FF7Z-T7GV'
        @key_deactivated = 'BMM9-4CMM-MMKY-HWY3'
        @account_number = '6803949191'
        @account = '1030956983'
        @printerserial = 'CN53IEW01B'
      else
        @printer = 'test.georgea+brazil@gmail.com'
        @printer_customer_account = ''
        @printer_customer_account_return = ''
        @printer_return = 'test testqa'
        @promo_expired = 'mustang'
        @promo_uk = 'integrationtestsuk'
        @promo_us = 'integrationtestsus'
        @promo_fr = 'integrationtestsfr'
        @promo_de = 'integrationtestsde'
        @promo_it = 'integrationtestsit'
        @promo_es = 'integrationtestses'
        @promo_ca = 'integrationtestsca'
        @key_activated = 'BXXZ-MFXH-KMRD-Y799'
        @key_redeemed = 'BAAB-GZAV-3GMK-WMNX'
        @key_deactivated = 'BHHV-TRHM-DTX4-WYSB'
        @account = '3317708006'
        @printerserial = 'TH46C151640650'
    end
  end

  def stacks
    %w(test1 pie1 stage1 localhost)
  end

  def is_stage
    return @env == 'stage1'
  end

  def roles
    %w(admin operations agent_lead agent)
  end

  def value_or_default(value, default)
    value.blank? ? default : value
  end

  def get_role(stack, role = DEFAULT_ROLE)
    STACKS[value_or_default(stack, DEFAULT_STACK).to_sym][role.to_sym]
  end

  def set_ast_specs_vars(args)
    args = { browser: DEFAULT_BROWSER, stack: DEFAULT_STACK, role: DEFAULT_ROLE, browser_path: '/usr/local/firefox' }.merge(args.to_hash || {})
    stack = args[:stack]
    current_role = args[:role]

    ENV['AST_DEFAULT_BROWSER'] = DEFAULT_BROWSER
    ENV['AST_BROWSER_TYPE'] = args[:browser]
    ENV['INTEGRATION'] = 'true'
    ENV['AST_STACK'] = stack
    ENV['APP_HOST'] = stack_url(stack)
    ENV['AST_TEST_ROLE'] = current_role if current_role
    path = args[:browser_path]
    ENV['PATH'] = "#{path}:#{ENV['PATH']}" if File.exists? path
    $logger.info "running on stack : #{stack}"
    $logger.info("path: #{ENV['PATH']}")
    $logger.info("running with role: #{current_role}")
  end

  def stack_url(stack)
    case stack
      when 'pie1'
        'https://instantink-pie1.hpconnectedpie.com'
      when 'test1'
        'https://instantink-test1.hpconnectedtest.com'
      when 'stage1'
        'https://instantink-stage1.hpconnectedstage.com'
      else
        nil
    end
  end

  def current_stack
    ENV['AST_STACK'] || DEFAULT_STACK
  end

  def setup_role role
    args = { stack: current_stack, role: role }
    set_ast_specs_vars(args)
    setup_ast_environment
  end

end
