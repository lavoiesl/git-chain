# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class BottomTest < Minitest::Test
      include RepositoryTestHelper

      def test_switches_to_bottom_branch
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "b")

          Bottom.new.call

          assert_equal("a", Git.current_branch)
        end
      end

      def test_chain_without_bottom_branch_raises
        with_test_repository("a-b-chain") do
          Git.exec("config", "branch.master.chain", "solo")
          Git.exec("checkout", "master")

          error = assert_raises(Abort) { Bottom.new.call }
          assert_equal("No bottom branch for {{info:master}} in chain solo", error.message)
        end
      end
    end
  end
end
