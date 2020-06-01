require './support/pageObjects/landingUtil/landing_map.rb'

include Landing_map

module Landing

  def set_value_to(locator, text)
    get_element(locator).set(text)
  end

  def get_element(locator)
    if(locator.instance_of?(String))
      element=all(:xpath, locator)[0]
    else
      element=nil
      locator.each do |loc|
        if(element==nil)
          element=find(:xpath, loc)
        else
          element=element.find(:xpath, loc)
        end
      end
    end
    return element
  end

  def click_element(locator)
    sleep(3)
    get_element(locator).click()
  end

end
