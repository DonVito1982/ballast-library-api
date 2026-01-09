shared_examples_for "a bad request" do
  it "responds with an unauthorized status" do
    expect(response).to have_http_status :bad_request
  end
end

shared_examples_for "an unauthorized request" do
  it "responds with an unauthorized status" do
    expect(response).to have_http_status :unauthorized
  end
end
