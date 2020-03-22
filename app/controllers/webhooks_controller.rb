class WebhooksController < ApplicationController
  before_action :validate_request
  before_action :find_repo

  def create
    if params.has_key?('commits')
      CommitService.process(commit_params, @repo.id)
    else
      ReleaseService.process(release_params, @repo.id)
    end
    render json: { result: true }
  end

  private

  def find_repo
    @repo = Repo.find_by(name: params.dig(:repository, :name))
  end

  def release_params
    params.permit(:action, :released_at, repository: [:id, :name],
                  release: [:id, :tag_name, :released_at, author: [:id, :name, :email],
                            commits: [:sha, :message, :date, author: [:id, :name, :email]]
                          ])
  end

  def commit_params
    params.permit(:pushed_at, pusher: [:id, :name, :email], repository: [:id, :name], 
                  commits: [:sha, :message, :date, author: [:id, :name, :email]]
                )
  end

  def validate_request
    return render json: { result: {} } unless %w[commits release].any? { |key| params.has_key?(key) }
  end
end
