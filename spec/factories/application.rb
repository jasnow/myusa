FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    ignore do
      owner nil
    end

    sequence(:name) {|n| "Client App #{n}" }
    # Redirect to the 'native_uri' so that Doorkeeper redirects us back to a token page in our app.
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    scopes 'profile.email profile.last_name'
    public true

    after(:create) do |a, evaluator|
      if evaluator.owner
        evaluator.owner.grant_role!(:owner, a)
      end
    end

    trait(:pending_approval) do
      requested_public_at DateTime.now
    end
  end
end
