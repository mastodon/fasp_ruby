module StubbedRequests
  def stub_fasp_registration
    stub_request(:post, "https://fedi.example.com/fasp/registration")
      .to_return_json(
        status: 201,
        body: {
          faspId: "dfkl3msw6ps3",
          publicKey: "KvVQVgD4/WcdgbUDWH7EVaYX9W7Jz5fGWt+Wg8h+YvI=",
          registrationCompletionUri: "https://fedi.example.com/admin/fasps"
        }
      )
  end
end
