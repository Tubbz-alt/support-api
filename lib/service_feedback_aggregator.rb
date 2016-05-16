class ServiceFeedbackAggregator

  def run(date)
    @date = date
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute(create_aggregate)
      ActiveRecord::Base.connection.execute(copy_to_archive)
      ActiveRecord::Base.connection.execute(delete_from_anonymous_contacts)
    end
  end

private
  def create_aggregate
    <<-SQL
    INSERT INTO anonymous_contacts (
      type,
      path,
      is_actionable,
      personal_information_status,
      created_at,
      updated_at,
      service_satisfaction_rating,
      details
    )
    SELECT
      'AggregatedServiceFeedback',
      path,
      true,
      'absent',
      DATE_TRUNC('day',created_at),
      DATE_TRUNC('day',created_at),
      service_satisfaction_rating,
      count(service_satisfaction_rating)
      FROM anonymous_contacts
      WHERE type = 'ServiceFeedback'
      AND created_at >= '#{@date}'
      AND created_at < '#{@date + 1.day}'
      GROUP BY 2, 5, 7;
    SQL
  end

  def copy_to_archive
    <<-SQL
    INSERT INTO archived_service_feedbacks (
      type,
      slug,
      created_at,
      service_satisfaction_rating
    )
    SELECT
      'ServiceFeedback',
      slug,
      DATE_TRUNC('day',created_at),
      service_satisfaction_rating
    FROM anonymous_contacts
    WHERE type = 'ServiceFeedback'
    AND created_at >= '#{@date}'
    AND created_at < '#{@date + 1.day}'
    SQL
  end

  def delete_from_anonymous_contacts
    <<-SQL
    DELETE FROM anonymous_contacts
    WHERE type = 'ServiceFeedback'
    AND details IS NULL
    AND created_at >= '#{@date}'
    AND created_at < '#{@date + 1.day}'
    SQL
  end
end
