# frozen_string_literal: true

RSpec.describe "Welcome" do
  subject(:action) { get(root_path) }

  it "returns :success" do
    action
    expect(response).to have_http_status(:success)
  end
end
