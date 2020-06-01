
module Landing_map
  
    Landing_map = {
		landingPage:{
			input_box:							'//*[@id="kw"]',
			search_button:					'//*[@id="su"]',
      }
    }
    
  def get_landing_xpath(id_name)
		return Landing_map[:landingPage][id_name]
	end
  
end
