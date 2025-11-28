# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class TopTest < Minitest::Test
      include RepositoryTestHelper

      def test_switches_to_top_branch
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "a")

          Top.new.call

          assert_equal("b", Git.current_branch)
        end
      end

      def test_requires_chain_membership
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "master")

          error = assert_raises(Abort) { Top.new.call }
          assert_equal("Current branch 'master' is not in a chain.", error.message)
        end
      end
    end
  end
end
