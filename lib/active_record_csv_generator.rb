# frozen_string_literal: true

##
# Generates CSV from ActiveRecord model attributes
#
# This generator can print both attribute columns as well as custom, lambda-
# controlled columns.
#
class ActiveRecordCSVGenerator
  # Initializes a new csv generator for a given resource
  #
  # A resource is an ActiveRecord model or something that obeys the same
  # interface. Column names can be specified in the `generate` method (so
  # one generator can generate many different csv reports), but each generator
  # focuses on a single resource.
  #
  # Example:
  #
  #     > user_generator = ActiveRecordCSVGenerator.new(User)
  #
  def initialize(resource)
    @resource = resource
  end

  # Generates a CSV given the target resource and list of columns.
  #
  # Columns can be either a string/symbolic attribute name (e.g. :created_at)
  # or a tuple of a column name and value function.
  #
  # Example:
  #
  #     > user_generator.generate(columns: [
  #       'name',
  #       :email,
  #       [:admin?,         ->(u) { u.admin? }],
  #       ['site manager?', ->(u) { u.site_manager? }],
  #       ['or whatever',   ->(_) { 'anything you want' }],
  #     ])
  #
  #     name,email,admin?,site manager?,or whatever
  #     Raj,user@example.com,true,false,anything you want
  #     Betsy,user2@example.com,false,false,anything you want
  #     ...
  #
  # CSV format is specified in the parameter list, which allows one generator
  # to generate many different reports.
  #
  # Example:
  #
  #     > user_report_1 = user_generator.generate(columns: report_1_cols)
  #     > user_report_2 = user_generator.generate(columns: report_2_cols)
  #
  def generate(columns:)
    columns = evaluate_columns(columns)

    CSV.generate do |csv|
      csv << columns[:headers]
      resource.all.each do |record|
        csv << columns[:fields].map { |f| f.call(record) }
      end
    end
  end

  private

  attr_reader :resource

  # Turn columns into a hash -> headers have column headers, fields have a
  # lambda with arity-1 that takes a record and returns field value.
  #
  # Example:
  #
  #     > evaluate_columns([:name, ['admin?', ->(r) { r.admin? }], :uid])
  #     {
  #       headers: ['name', 'admin?', 'uid'],
  #       fields: [
  #         ->(r) { r.attributes['name'] },
  #         ->(r) { r.admin? },
  #         ->(r) { r.attributes['uid'] },
  #       ]
  #     }
  #
  def evaluate_columns(columns)
    columns.each_with_object(headers: [], fields: []) do |column, acc|
      if column.is_a? Array
        acc[:headers] << column[0].to_s
        acc[:fields]  << column[1]
      else
        acc[:headers] << column.to_s
        acc[:fields]  << ->(record) { record.attributes[column.to_s] }
      end
    end
  end
end
