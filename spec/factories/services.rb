FactoryBot.define do
  factory :service do
    patron { nil }
    provider { "MyString" }
    uid { "MyString" }
    access_token { "MyString" }
    access_token_secret { "MyString" }
    refresh_token { "MyString" }
    expires_at { "2024-02-15 11:58:26" }
    auth { "MyText" }
  end
end
