require 'test_helper'

class RepoTest < ActiveSupport::TestCase
  test "repo not valid without name" do
    user = User.new
    assert_not user.valid?
    assert_equal user.errors.messages[:name], ["can't be blank"]
  end

  test "valid repo" do
    repo = Repo.create(name: 'test')
    assert_not repo.id.nil?
    assert_equal repo.name, 'test'
  end
end
