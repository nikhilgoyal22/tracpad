require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  test "release not valid without tag_name" do
    release = Release.new(repo: repos(:one), user: users(:one))
    assert_not release.valid?
    assert_equal release.errors.messages[:tag_name], ["can't be blank"]
  end

  test "valid release" do
    release = Release.create(tag_name: '1.0.0', repo: repos(:one), user: users(:one))
    assert_not release.id.nil?
    assert_equal release.tag_name, '1.0.0'
  end

  test "posting_data" do
    release = Release.create(tag_name: '1.0.0', repo: repos(:one), user: users(:one))
    Commit.create(sha: 'testsha', commit_type: 'FIX', tickets: ['test-123', 'test-456'],
                  release: release, repo: repos(:one), user: users(:one))

    assert_not release.id.nil?
    assert_equal release.commits.count, 1
    assert_equal release.posting_data, {
                                        "query": "state released",
                                        "issues": [{ "id": 'test-123' }, { "id": 'test-456' }],
                                        "comment": "Released in 1.0.0"
                                      }.to_json
  end
end
