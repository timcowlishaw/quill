RSpec.configure do |c|
  c.expect_with :rspec do |conf|
    conf.syntax = :expect
  end

  c.mock_with :rspec do |conf|
    conf.syntax = :expect
  end

  c.order = :random
end
