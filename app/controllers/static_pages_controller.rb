class StaticPagesController < ApplicationController
  def home
    @activities = Activity.all.preload( user: :user_profile, trackable: [job_post: :job_type])
    @job_types = JobType.all
    @post = Post.new
    @post.build_job_post
  end
end
