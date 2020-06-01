require 'spec_helper'

describe 'Provide Feedback', type: :feature do
  context 'test provide feedback' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      it 'verifying provide feedback' do
        click_link 'Provide feedback'
        expect(page).to have_content 'Tell us what you think about the support tool'
        fill_in 'feedback', with: 'blablablablablablablablablablabla'
        click_button 'Send'
        expect(page).to have_content('Feedback received')
      end
    end
  end
end
