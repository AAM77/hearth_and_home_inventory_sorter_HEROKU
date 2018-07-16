require_relative "../spec_helper"
require 'pry'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Hearth and Home Inventory Organizer")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to folders index' do
      params = {
        :username => "shellfish99",
        :email => "shelf_fish@testy.com",
        :password => "shrimper123"
      }
      post '/signup', params
      expect(last_response.location).to include("/folders")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "shelf_fish@testy.com",
        :password => "shrimper123"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :username => "shellfish99",
        :email => "",
        :password => "shrimper123"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :username => "shellfish99",
        :email => "shelf_fish@testy.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'creates a new user and logs them in on valid submission and does not let a logged in user view the signup page' do
      params = {
        :username => "shellfish99",
        :email => "shelf_fish@testy.com",
        :password => "shrimper123"
      }
      post '/signup', params
      get '/signup'
      expect(last_response.location).to include('/folders')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the folders index after login' do
      user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
      params = {
        :username => "jimmy123",
        :password => "froglets"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
      params = {
        :username => "jimmy123",
        :password => "froglets"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/folders")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")

      params = {
        :username => "jimmy123",
        :password => "froglets"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /folders if user not logged in' do
      get '/folders'
      expect(last_response.location).to include("/login")
    end

    it 'does load /folders if user is logged in' do
      user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")


      visit '/login'

      fill_in(:username, :with => "jimmy123")
      fill_in(:password, :with => "froglets")
      click_button 'submit'
      expect(page.current_path).to eq('/folders')
    end
  end

  describe 'user show page' do
    it 'shows all a single users folders' do
      user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
      folder1 = Folder.create(:name => "Donating", :user_id => user.id)
      folder2 = Folder.create(:name => "Lending", :user_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("Donating")
      expect(last_response.body).to include("Lending")

    end
  end

  ##################################################################
  ## This needs to change                                         ##
  ## Each user has access to only his or her own personal folders ##
  ## A user cannot see folders created by other users             ##
  ## ** Each User initializes with three pre-created folders!! ** ##
  ## ** TEST FOR THIS **                                          ##
  ##################################################################

  describe 'index action' do
    context 'logged in' do
      it 'does not let the user view the folders index of another user if logged in' do
        user1 = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        folder1 = Folder.create(:name => "Donating", :user_id => user1.id)

        user2 = User.create(:username => "goldylocks33", :email => "goldy_locks@testy.com", :password => "bears")
        folder2 = Folder.create(:name => "Lending", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'
        visit "/folders"
        expect(page.body).to include(folder1.name)
        expect(page.body).to include(folder2.name)
      end
    end

    context 'logged out' do
      it 'does not let a user view the folders index if not logged in' do
        get '/folders'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new folder form if logged in' do
        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")

        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'
        visit '/folders/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a folder if he or she is logged in' do
        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")

        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'

        visit '/folders/new'
        fill_in(:name, :with => "Throwing Away")
        click_button 'submit'

        user = User.find_by(:username => "jimmy123")
        folder = Folder.find_by(:name => "Throwing Away")
        expect(folder).to be_instance_of(Folder)
        expect(folder.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create a folder from another user' do
        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        user2 = User.create(:username => "goldylocks33", :email => "goldy_locks@testy.com", :password => "bears")

        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'

        visit '/folders/new'

        fill_in(:name, :with => "Throwing Away")
        click_button 'submit'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        folder = Folder.find_by(:name => "Throwing Away")
        expect(folder).to be_instance_of(Folder)
        expect(folder.user_id).to eq(user.id)
        expect(folder.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank folder name' do
        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")

        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'

        visit '/folders/new'

        fill_in(:name, :with => "")
        click_button 'submit'

        expect(Folder.find_by(:name => "")).to eq(nil)
        expect(page.current_path).to eq("/folders/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new folder form if not logged in' do
        get '/folders/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single folder' do

        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        folder = Folder.create(:name => "Storage", :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'

        visit "/folders/#{folder.id}" ## MAKE THIS A SLUG FOR THE FOLDER NAME
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Folder")
        expect(page.body).to include(folder.name)
        expect(page.body).to include("Edit Folder")
      end
    end

    context 'logged out' do
      it 'does not let a user view a folder' do
        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        folder = Folder.create(:name => "Storage", :user_id => user.id)
        get "/folders/#{folder.id}" ## MAKE THIS A SLUG FOR THE FOLDER NAME
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view folder edit form if he or she is logged in' do
        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        folder = Folder.create(:name => "Donating", :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'
        visit '/folders/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(folder.name)
      end

      it 'does not let a user edit a folder her or she did not create' do
        user1 = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        folder1 = Folder.create(:name => "Donating", :user_id => user1.id)

        user2 = User.create(:username => "goldylocks33", :email => "goldy_locks@testy.com", :password => "bears")
        folder2 = Folder.create(:name => "Miscellaneous", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'
        visit "/folders/#{folder2.id}/edit"
        expect(page.current_path).to include('/folders')
      end

      it 'lets a user edit his or her own folder if logged in' do
        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        folder = Folder.create(:name => "Donating", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'
        visit '/folders/1/edit'

        fill_in(:name, :with => "i love foldering")

        click_button 'submit'
        expect(Folder.find_by(:name => "i love foldering")).to be_instance_of(Folder)
        expect(Folder.find_by(:name => "Donating")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a folder name with a blank name' do
        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        folder = Folder.create(:name => "Donating", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'
        visit '/folders/1/edit'

        fill_in(:name, :with => "")

        click_button 'submit'
        expect(Folder.find_by(:name => "i love foldering")).to be(nil)
        expect(page.current_path).to eq("/folders/1/edit")
      end
    end

    context "logged out" do
      it 'does not load -- instead redirects to login' do
        get '/folders/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own folder if they are logged in' do
        user = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        folder = Folder.create(:name => "Donating", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'
        visit 'folders/1'
        click_button "Delete Folder"
        expect(page.status_code).to eq(200)
        expect(Folder.find_by(:name => "Donating")).to eq(nil)
      end

      it 'does not let a user delete a folder they did not create' do
        user1 = User.create(:username => "jimmy123", :email => "silhouette@testy.com", :password => "froglets")
        folder1 = Folder.create(:name => "Donating", :user_id => user1.id)

        user2 = User.create(:username => "goldylocks33", :email => "goldy_locks@testy.com", :password => "bears")
        folder2 = Folder.create(:name => "Storage", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "jimmy123")
        fill_in(:password, :with => "froglets")
        click_button 'submit'
        visit "folders/#{folder2.id}"
        click_button "Delete Folder"
        expect(page.status_code).to eq(200)
        expect(Folder.find_by(:name => "Storage")).to be_instance_of(Folder)
        expect(page.current_path).to include('/folders')
      end
    end

    context "logged out" do
      it 'does not load let user delete a folder if not logged in' do
        folder = Folder.create(:name => "Donating", :user_id => 1)
        visit '/folders/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
end
