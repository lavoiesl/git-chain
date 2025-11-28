# frozen_string_literal: true

module GitChain
  module Commands
    class Up < Command
      include Options::ChainName

      def description
        "Switch to the child of the current branch."
      end

      def run(options)
        branch_name = Git.current_branch
        raise(Abort, "Not currently on a branch") unless branch_name

        chain = current_chain(options)
        index = chain.branches.index { |b| b.name == branch_name }
        raise(Abort, "Unable to find current branch {{info:#{branch_name}}} in chain #{chain.name}") if index == -1

        child_branch = chain.branches[index + 1]
        raise(Abort, "No child branch for {{info:#{branch_name}}} in chain #{chain.name}") unless child_branch

        Git.exec("checkout", child_branch.name)
      end
    end
  end
end
