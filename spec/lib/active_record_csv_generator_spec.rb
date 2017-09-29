require "active_record_csv_generator"

describe ActiveRecordCSVGenerator do
  describe ".generate" do
    context "with a resource that adheres to the ActiveRecord interface" do
      FakeUser = Struct.new(:name)
      let(:ar_resource) do
        db = { headers: ["id", "name", "user_id"],
               values:  [   1, "DC General", "1"] }

        # double of a wishlist instance
        record = instance_double "Wishlist"
        allow(record).to receive("attributes") do
          db[:headers].zip(db[:values]).to_h
        end
        users = [FakeUser.new("Jason"), FakeUser.new("Polly")]
        allow(record).to receive_message_chain("users") { users }

        # double of the Wishlist model
        double "Wishlist", column_names: db[:headers],
                           all: [record]
      end

      let(:generator) { ActiveRecordCSVGenerator.new(ar_resource) }

      it "generates a csv" do
        csv = generator.generate(columns: [:id, :name])
        expect(csv).to eq "id,name\n1,DC General\n"
      end

      context "when a value is an association" do
        it "should return the association value" do
          site_managers_string = ->(record) { record.users.map(&:name).join(" ")}
          csv = generator.generate(columns: [
              :id,
              :name,
              [:site_managers, site_managers_string]
          ])
          expect(csv).to eq "id,name,site_managers\n1,DC General,Jason Polly\n"
        end
      end

      context "when a value is an arbitrary lambda" do
        it "should include key as the col name and result as value" do
          csv = generator.generate(columns: [:name, [:age, ->(_) { 10 }]])
          expect(csv).to eq "name,age\nDC General,10\n"
        end
      end
    end
  end
end
