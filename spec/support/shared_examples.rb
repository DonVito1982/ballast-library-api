shared_examples_for "a bad request" do
  it "responds with a bad request status" do
    expect(response).to have_http_status :bad_request
  end
end

shared_examples_for "an unauthenticated request" do
  it "responds with an unauthorized status" do
    expect(response).to have_http_status :unauthorized
  end
end

shared_examples_for "an unauthorized request" do
  it "responds with a forbidden status" do
    expect(response).to have_http_status :forbidden
  end
end
