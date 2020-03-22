require 'test_helper'

class CommitTest < ActiveSupport::TestCase
  test "commit not valid without sha" do
    commit = Commit.new(repo: repos(:one), user: users(:one))
    assert_not commit.valid?
    assert_equal commit.errors.messages[:sha], ["can't be blank"]
    assert_equal commit.errors.messages[:commit_type], ["is not included in the list"]
  end

  test "commit not valid" do
    commit = Commit.create(sha: 'testsha', commit_type: 'FIX', repo: repos(:one), user: users(:one))
    assert_not commit.id.nil?
    assert_equal commit.sha, 'testsha'
  end

  test "posting_data" do
    commit = Commit.create(sha: 'testsha', commit_type: 'FIX', tickets: ['test-123', 'test-456'],
                           repo: repos(:one), user: users(:one))
    assert_not commit.id.nil?
    assert_equal commit.tickets, ['test-123', 'test-456']
    assert_equal commit.posting_data, {
                                        "query": "state ready for release",
                                        "issues": [{ "id": 'test-123' }, { "id": 'test-456' }],
                                        "comment": "See SHA #testsha"
                                      }.to_json
  end
end
