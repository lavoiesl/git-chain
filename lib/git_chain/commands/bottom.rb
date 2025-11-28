# frozen_string_literal: true

module GitChain
  module Commands
    class Bottom < Command
      include Options::ChainName

      def description
        "Switch to the branch closest to trunk in the current stack."
      end

      def run(options)
        branch_name = Git.current_branch
        raise(Abort, "Not currently on a branch") unless branch_name

        chain = current_chain(options)
        child_branch = chain.branches[1]
        raise(Abort, "No bottom branch for {{info:#{branch_name}}} in chain #{chain.name}") unless child_branch

        Git.exec("checkout", child_branch.name)
      end
    end
  end
end
