# frozen_string_literal: true

module GitChain
  module Commands
    class Parent < Command
      def description
        "Display the parent of the current branch"
      end

      def run(_options)
        branch_name = Git.current_branch
        raise(Abort, "Not currently on a branch") unless branch_name

        branch = Models::Branch.from_config(branch_name)
        parent_name = branch.parent_branch

        raise(Abort, "No parent branch configured for {{info:#{branch_name}}}") unless parent_name

        puts parent_name
      end
    end
  end
end
