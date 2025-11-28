# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class DownTest < Minitest::Test
      include RepositoryTestHelper

      def test_switches_to_parent_branch
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "b")

          Down.new.call

          assert_equal("a", Git.current_branch)
        end
      end

      def test_missing_parent_branch_raises
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "master")

          error = assert_raises(Abort) { Down.new.call }
          assert_equal("No parent branch configured for {{info:master}}", error.message)
        end
      end
    end
  end
end
