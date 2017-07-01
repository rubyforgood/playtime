##
# Generates CSV from ActiveRecord model attributes
#
# This generator is not customizable–when given a resource, it will take all
# attributes as columns and dump all records into the CSV.
#
class ActiveRecordCSVGenerator
  def initialize(resource)
    @resource = resource
  end

  def generate
    CSV.generate do |csv|
      csv << resource.column_names
      resource.all.each do |record|
        csv << record.attributes.values
      end
    end
  end

  private

  attr_reader :resource
end
