# frozen_string_literal: true

require 'active_record_csv_generator'

describe ActiveRecordCSVGenerator do
  describe '.generate' do
    context 'with a resource that adheres to the ActiveRecord interface' do
      # Set an initial db state of one wishlist with two site managers.
      before do
        create(:wishlist, name: 'DC General', id: 1, users: [
                 create(:user, name: 'Jason'),
                 create(:user, name: 'Polly')
               ])
      end
      let(:ar_resource) { Wishlist }
      let(:generator)   { ActiveRecordCSVGenerator.new(ar_resource) }

      it 'generates a csv' do
        csv = generator.generate(columns: %i[id name])
        expect(csv).to eq "id,name\n1,DC General\n"
      end

      context 'when a value is an association' do
        it 'should return the association value' do
          site_managers_string = ->(record) { record.users.map(&:name).join(' ') }
          csv = generator.generate(columns: [
                                     :id,
                                     :name,
                                     [:site_managers, site_managers_string]
                                   ])
          expect(csv).to eq "id,name,site_managers\n1,DC General,Jason Polly\n"
        end
      end

      context 'when a value is an arbitrary lambda' do
        it 'should include key as the col name and result as value' do
          csv = generator.generate(columns: [:name, [:age, ->(_) { 10 }]])
          expect(csv).to eq "name,age\nDC General,10\n"
        end
      end
    end
  end
end
