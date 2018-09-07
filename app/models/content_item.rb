class ContentItem < ApplicationRecord
  has_and_belongs_to_many :organisations
  has_many :problem_reports, class_name: "ProblemReport"
  has_many :anonymous_contacts
  validates :path, presence: true

  scope :for_organisation, ->(organisation) {
    joins(:organisations).
    where(organisations: { id: organisation.id})
  }

  scope :for_document_type, ->(document_type) {
    where(document_type: document_type)
  }

  def self.summary(ordering = "last_7_days")
    ordering_mode = ordering == "path" ? "ASC" : "DESC"

    query = joins(:anonymous_contacts)
      .select("content_items.path AS path")
      .select("#{last_7_days} AS last_7_days")
      .select("#{last_30_days} AS last_30_days")
      .select("#{last_90_days} AS last_90_days")
      .where("anonymous_contacts.created_at > ?", midnight_last_night - 90.days)
      .group("content_items.path")
      .having("#{last_7_days} + #{last_30_days} + #{last_90_days} > 0")
      .order("#{ordering} #{ordering_mode}")

    connection.
      select_all(query).
      map(&:symbolize_keys).
      map { |row| integers_for_sum_columns(row) }
  end

  def self.doctype_summary(ordering: "last_7_days", document_type: nil)
    ordering_mode = ordering == "document_type" ? "ASC" : "DESC"

    query = joins(:anonymous_contacts)
        .select("content_items.document_type as document_type")
        .select("#{last_7_days} AS last_7_days")
        .select("#{last_30_days} AS last_30_days")
        .select("#{last_90_days} AS last_90_days")
        .where(document_type: document_type)
        .where("anonymous_contacts.created_at > ?", midnight_last_night - 90.days)
        .group("content_items.document_type")
        .having("#{last_7_days} + #{last_30_days} + #{last_90_days} > 0")
        .order("#{ordering} #{ordering_mode}")

    connection.
        select_all(query).
        map(&:symbolize_keys).
        map { |row| integers_for_sum_columns(row) }
  end

  def fetch_organisations
    self.organisations = Organisation.for_path(path)
    save!
  end

  def self.all_document_types
    self.distinct.pluck(:document_type).reject { |d| d == '' }.compact
  end

  def self.midnight_last_night
    Date.today.to_time(:utc)
  end

  def self.last_7_days
    sum_column(from: midnight_last_night - 7.days, to: midnight_last_night)
  end

  def self.last_30_days
    sum_column(from: midnight_last_night - 30.days, to: midnight_last_night)
  end

  def self.last_90_days
    sum_column(from: midnight_last_night - 90.days, to: midnight_last_night)
  end

private

  def self.sum_column(options)
    "SUM(
       CASE WHEN anonymous_contacts.created_at BETWEEN '#{options[:from].to_s(:db)}' AND '#{options[:to].to_s(:db)}' THEN 1
            ELSE 0
            END
        )"
  end

  def self.integers_for_sum_columns(row)
    # the pg ActiveRecord adapter returns strings, even for SUM columns
    # see http://stackoverflow.com/questions/12571215/connection-select-value-only-returns-strings-in-postgres-with-pg-gem
    Hash[row.map {|key,value| [key, (key == :path ? value : value.to_i)] }]
  end
end
