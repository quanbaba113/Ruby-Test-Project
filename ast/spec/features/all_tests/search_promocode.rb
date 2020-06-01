require 'spec_helper'

describe 'Search PromoCode', type: :feature do

  before(:each) do
    setup_ast_environment
  end

  context 'test promocode search in Welcome Page ' do
    before do
      login_as @user, @password
    end

    it 'search by expired promocode' do
      fill_in 'promo-code-search-key', with: @promo_expired
      click_on 'btn-promo-code-search'
      wait_for_ajax
      find('.btn-link').click
      expect(page).to have_content 'Details of Promo code'
    end

    it 'search by unknown promocode' do
      fill_in 'promo-code-search-key', with: 'blablabla'
      click_on 'btn-promo-code-search'
      expect(page).to have_content('Promo code not found')
    end

    it 'search by active uk promocode' do
      @country = 'uk'
      find(".selectpicker[data-id='promo-code-search-country']").click
      find("#promo-code-search .flag-#{@country}").click
      fill_in 'promo-code-search-key', with: @promo_uk
      click_on 'btn-promo-code-search'
      expect(page).to have_content('Expire: 06/29/2016')
      find('.btn-link').click
      expect(page).to have_content 'Details of Promo code'
    end

    it 'search by active fr promocode' do
      @country = 'fr'
      find(".selectpicker[data-id='promo-code-search-country']").click
      find("#promo-code-search .flag-#{@country}").click
      fill_in 'promo-code-search-key', with: @promo_fr
      click_on 'btn-promo-code-search'
      wait_for_ajax
      find('.btn-link').click
      expect(page).to have_content 'Details of Promo code'
    end

    it 'search by active de promocode' do
      @country = 'de'
      find(".selectpicker[data-id='promo-code-search-country']").click
      find("#promo-code-search .flag-#{@country}").click
      fill_in 'promo-code-search-key', with: @promo_de
      click_on 'btn-promo-code-search'
      expect(page).to have_content('Expire: 06/29/2016')
      find('.btn-link').click
      expect(page).to have_content 'Details of Promo code'
    end

    it 'search by active es promocode' do
      @country = 'es'
      find(".selectpicker[data-id='promo-code-search-country']").click
      find("#promo-code-search .flag-#{@country}").click
      fill_in 'promo-code-search-key', with: @promo_es
      click_on 'btn-promo-code-search'
      expect(page).to have_content('Expire: 06/29/2016')
      find('.btn-link').click
      expect(page).to have_content 'Details of Promo code'
    end

    it 'search by active ca promocode' do
      @country = 'ca'
      find(".selectpicker[data-id='promo-code-search-country']").click
      find("#promo-code-search .flag-#{@country}").click
      fill_in 'promo-code-search-key', with: @promo_ca
      click_on 'btn-promo-code-search'
      expect(page).to have_content('Expire: 06/29/2016')
      find('.btn-link').click
      expect(page).to have_content 'Details of Promo code'
    end

    it 'view all promocodes' do
      click_link 'View All Promo Codes'
      expect_content(['All Promo Codes', 'Name', 'Code', 'Country'])
      fill_in 'promo-code', with: @promo_expired
      click_on 'btn-search-promo-code'
      expect(page).to have_content 'US'
      find('.glyphicon-plus').click
      expect_content(['Start Date', 'End Date', 'Plans Incentive'])
    end
  end
end
