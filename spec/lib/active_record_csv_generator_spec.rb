require "active_record_csv_generator"

describe ActiveRecordCSVGenerator do
  describe ".generate" do
    context "with a resource that adheres to the ActiveRecord interface" do
      let(:ar_resource) do
        db = { headers: ["id", "name"],
               values:  [   1, "DC General"] }

        # double of a wishlist instance
        record = instance_double "Wishlist"
        allow(record).to receive_message_chain("attributes.values") { db[:values] }

        # double of the Wishlist model
        double "Wishlist", column_names: db[:headers],
                           all: [record]
      end

      subject(:csv) { ActiveRecordCSVGenerator.new(ar_resource).generate }

      it "generates a csv" do
        expect(csv).to eq "id,name\n1,DC General\n"
      end
    end
  end
end
