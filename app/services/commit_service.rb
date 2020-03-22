class CommitService
  def self.process(options, repo_id, release = false)
    options.dig(:commits).map do |obj|
      commit = Commit.find_by(sha: obj[:sha])
      commit ||= Commit.create(commit_options(obj, repo_id))
      RestClient.post(ENV['POSTING_URI'], commit.posting_data) unless release

      commit
    end
  end

  private

  def self.commit_options(options, repo_id)
    {
      sha: options[:sha],
      committed_at: options[:date],
      user: User.add_user(options.dig(:author)),
      repo_id: repo_id
    }.merge(ticket_options(options[:message]))
  end

  def self.ticket_options(message)
    comment, issues = message.split("\n\n")
    commit_type, description = comment.split(': ')
    {
      commit_type: commit_type,
      description: description,
      tickets: issues.gsub('Ref: ', '').split(', ').map{|t| t.gsub('#', '')}
    }
  end

end