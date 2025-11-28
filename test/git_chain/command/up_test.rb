# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class UpTest < Minitest::Test
      include RepositoryTestHelper

      def test_switches_to_child_branch
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "a")

          Up.new.call

          assert_equal("b", Git.current_branch)
        end
      end

      def test_missing_child_branch_raises
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "b")

          error = assert_raises(Abort) { Up.new.call }
          assert_equal("No child branch for {{info:b}} in chain default", error.message)
        end
      end
    end
  end
end
