##
# Generates CSV from ActiveRecord model attributes
#
# This generator can print both attribute columns as well as custom, lambda-
# controlled columns.
#
class ActiveRecordCSVGenerator
  def initialize(resource)
    @resource = resource
  end

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
  def evaluate_columns(columns)
    columns.reduce({headers:[], fields:[]}) do |acc, column|
      if column.is_a? Array
        acc[:headers] << column[0]
        acc[:fields]  << column[1]
      else
        acc[:headers] << column
        acc[:fields]  << ->(record) { record.attributes[column.to_s] }
      end
      acc
    end
  end
end
