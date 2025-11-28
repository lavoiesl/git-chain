# frozen_string_literal: true

module GitChain
  module Commands
    class Top < Command
      include Options::ChainName

      def description
        "Switch to the tip branch of the current stack."
      end

      def run(options)
        branch_name = Git.current_branch
        raise(Abort, "Not currently on a branch") unless branch_name

        chain = current_chain(options)
        child_branch = chain.branches.last
        raise(Abort, "No top branch for {{info:#{branch_name}}} in chain #{chain.name}") unless child_branch

        Git.exec("checkout", child_branch.name)
      end
    end
  end
end
