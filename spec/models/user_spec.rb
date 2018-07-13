require 'pry'

describe 'User' do
  before do
    @user = User.create(:username => "test abc 123", :email => "test_abc_123@testing.com", :password => "@abc123")
  end #before

  it 'can slug the username' do
    expect(@user.slug).to eq ("test-abc-123")
  end #can slug

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).username).to eq("test abc 123")
  end #can find user

  it 'has a secure password' do
    expect(@user.authenticate("dog")).to eq(false)
    expect(@user.authenticate("@abc123")).to eq(@user)
  end #has secure password
end #class User describe
