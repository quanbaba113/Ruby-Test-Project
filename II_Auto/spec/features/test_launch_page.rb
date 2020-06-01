require 'spec_helper'
require './support/pageObjects/landingUtil/landing.rb'

include Landing

describe 'This is demo' , :type => :feature do

  it 'open website' do
    visit("https://www.baidu.com")   #打开测试网页(这里例子用的是百度)
    sleep(5)  # 这里sleep是用来等待,便于demo演示
    set_value_to(get_landing_xpath(:input_box), "beyondsoft")  #get_landing_xpath(:input_box)为输入框的定位, "beyondsoft"为输入案例信息
    sleep(10) # 这里sleep是用来等待,便于demo演示
    click_element(get_landing_xpath(:search_button))   #click_element为点击功能, 具体方法请按住ctrl键，用鼠标左键点击相应方法既可看到底层
    sleep(5) # 这里sleep是用来等待,便于demo演示
  end

 end