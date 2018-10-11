RSpec.describe Sidekiq::Scheduler::Mock do
  it "has a version number" do
    expect(Sidekiq::Scheduler::Mock::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
