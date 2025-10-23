module Barbeque
  class SnsSubscription < ApplicationRecord
    belongs_to :job_queue
    belongs_to :job_definition
    has_one :app, through: :job_definition

    validates :topic_arn,
      uniqueness: { scope: :job_queue, message: 'should be set with only one queue' },
      presence: true
    validate :topic_arn_is_formatted

    def topic_region
      Aws::ARNParser.parse(topic_arn).region
    end

    private

    def topic_arn_is_formatted
      unless Aws::ARNParser.arn?(topic_arn)
        errors.add(:topic_arn, 'is not a valid ARN')
      end
    end
  end
end
