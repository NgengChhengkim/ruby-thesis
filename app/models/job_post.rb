class JobPost < ApplicationRecord
  belongs_to :post

  has_many :apply_jobs, dependent: :destroy
  has_many :job_post_types, dependent: :destroy
  has_many :job_types, through: :job_post_types

  validates :name, presence: true
  validates :location, presence: true
  validates :job_types, presence: true
  validate :salary_validate
  validates :min_salary, numericality: {greater_than: 0, allow_nil: true}
  validates :max_salary, numericality: {greater_than: :min_salary, allow_nil: true},
    if: Proc.new {min_salary.present?}

  delegate :name, to: :job_type, prefix: true, allow_nil: true
  delegate :user_id, :content, to: :post, prefix: true, allow_nil: true

  scope :by_user, ->user_id do
    joins(:post).where("posts.user_id = ?", user_id).preload(:job_type)
    .order created_at: :desc
  end

  private
  def salary_validate
    if negotiable == false && min_salary.blank? && max_salary.blank?
      errors.add :base, I18n.t("posts.job_post_error")
    end
  end
end
