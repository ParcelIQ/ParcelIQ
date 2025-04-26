# Disable the Minitest adapter used by RSpec Rails
# This is needed to avoid conflicts in the controller tests
module RSpec
  module Rails
    module MinitestLifecycleAdapter
      def self.run(name, block)
        # Override to do nothing - skip Minitest integration
        yield if block_given?
      end
    end
  end
end
