require 'test_helper'
require 'json'

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  def file_path(filename)
    Rails.root.join('test', 'fixtures', 'files', filename)
  end

  def setup
    ENV['POSTING_URI'] = 'https://www.example.com'
    Commit.delete_all
    Release.delete_all
  end

  test "pull request api request" do
    file = File.read(file_path('pull_request.json'))
    post webhooks_url, params: JSON.parse(file)

    assert_equal JSON.parse(response.body)['result'], {}
    assert_response :success
  end

  test "commits api request" do
    file = File.read(file_path('commits.json'))
    post webhooks_url, params: JSON.parse(file)

    assert_equal Commit.count, 2

    assert JSON.parse(response.body)['result']
    assert_response :success
  end

  test "release api request" do
    file = File.read(file_path('release.json'))
    post webhooks_url, params: JSON.parse(file)

    assert_equal Release.count, 1
    release = Release.first
    assert_equal release.commits.count, 2

    assert JSON.parse(response.body)['result']
    assert_response :success
  end

end
