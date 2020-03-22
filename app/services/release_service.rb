class ReleaseService
  def self.process(options, repo_id)
    release = Release.find_by(tag_name: options.dig(:release, :tag_name))
    release ||= create_release(options, repo_id)
    commits = CommitService.process(options.dig(:release), repo_id, true)
    Commit.where(id: commits.map(&:id)).update_all(release_id: release.id)
    RestClient.post(ENV['POSTING_URI'], release.posting_data)
  end

  private

  def self.create_release(options, repo_id)
    Release.create(
      tag_name: options.dig(:release, :tag_name),
      released_at: options.dig(:released_at),
      uid: options.dig(:release, :id),
      repo_id: repo_id,
      user: User.add_user(options.dig(:release, :author))
    )
  end

end