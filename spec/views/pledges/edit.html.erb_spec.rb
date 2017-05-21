require 'rails_helper'

RSpec.describe "pledges/edit", type: :view do

  before(:each) do
    @pledge = assign(:pledge, Pledge.create!(
      item: Item.create!,
      user: User.create!(email: 'email@email.com')
    ))
  end

  it "renders the edit pledge form" do
    render

    assert_select "form[action=?][method=?]", pledge_path(@pledge), "post" do

      assert_select "input[name=?]", "pledge[item_id]"

      assert_select "input[name=?]", "pledge[user_id]"
    end
  end
end
