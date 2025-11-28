# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class ParentTest < Minitest::Test
      include RepositoryTestHelper

      def test_prints_parent_branch
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "b")
          out, _ = capture_io { Parent.new.call }
          assert_equal("a\n", CLI::UI::ANSI.strip_codes(out))
        end
      end

      def test_not_on_branch_raises
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "b")
          Git.exec("checkout", Git.rev_parse("b"))
          error = assert_raises(Abort) { Parent.new.call }
          assert_equal("Not currently on a branch", error.message)
        end
      end

      def test_missing_parent_branch_raises
        with_test_repository("a-b-chain") do
          Git.exec("checkout", "master")
          error = assert_raises(Abort) { Parent.new.call }
          assert_equal("No parent branch configured for {{info:master}}", error.message)
        end
      end
    end
  end
end
