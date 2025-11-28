# frozen_string_literal: true

require File.expand_path("../vendor/bootstrap.rb", __dir__)
require "git_chain"

require "minitest"
require "mocha/minitest"
require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use!
CLI::UI.enable_color = true

require "tmpdir"
require "fileutils"
require "tempfile"
require "open3"
require "digest"

module RepositoryTestHelper
  def with_test_repository(fixture_name = "a-b")
    tarball_path = prepare_fixture_tarball(fixture_name)

    with_temp_dir do |_dir|
      out, err, status = Open3.capture3("tar", "-xf", tarball_path)
      unless status.success?
        message = err.empty? ? out : err
        raise "Cannot extract fixture tarball #{tarball_path}: #{message}"
      end

      yield
    end
  end

  def with_temp_dir(prefix: "git-chain-rebase")
    previous_dir = Dir.pwd

    Dir.mktmpdir(prefix) do |dir|
      Dir.chdir(dir)
      yield(dir)
    ensure
      Dir.chdir(previous_dir) if previous_dir
    end
  end

  private

  def fixture_path(name)
    File.expand_path("../../fixtures/#{name}", __FILE__)
  end

  def fixture_tarball_path(name)
    script_path = fixture_script_path(name)
    hash = Digest::SHA1.file(script_path).hexdigest
    fixture_path("#{name}-#{hash[0..16]}.tar")
  end

  def fixture_script_path(name)
    fixture_path("#{name}.sh")
  end

  def prepare_fixture_tarball(fixture_name)
    tarball_path = fixture_tarball_path(fixture_name)
    return tarball_path if File.exist?(tarball_path)

    tmp_tarball_path = "#{tarball_path}.tmp"
    FileUtils.mkdir_p(File.dirname(tarball_path))
    FileUtils.rm_f(tmp_tarball_path)

    _with_test_repository(fixture_name) do |repo_dir|
      Dir.chdir(repo_dir) do
        out, err, status = Open3.capture3("tar", "-cf", tmp_tarball_path, ".")
        unless status.success?
          FileUtils.rm_f(tmp_tarball_path)
          message = err.empty? ? out : err
          raise "Cannot create fixture tarball #{tarball_path}: #{message}"
        end
      end
    end

    FileUtils.mv(tmp_tarball_path, tarball_path, force: true)
    tarball_path
  end

  def _with_test_repository(name)
    setup_script = fixture_script_path(name)

    with_temp_dir do |dir|
      _, err, stat = Open3.capture3(setup_script)
      raise "Cannot setup git repository using #{setup_script}: #{err}" unless stat.success?

      yield(dir)
    end
  end
end

module Minitest
  class Test
    def capture_io(&)
      cap = CLI::UI::StdoutRouter::Capture.new(with_frame_inset: true, &)
      cap.run
      [cap.stdout, cap.stderr]
    end
  end
end
