shared_examples_for "an unauthorized request" do
  it "responds with an unauthorized status" do
    expect(response).to have_http_status :unauthorized
  end
end
