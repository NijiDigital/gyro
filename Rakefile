
namespace :pr do
  desc 'Check incoming PRs on CI'
  task :check do
    if ENV['CI_PULL_REQUEST'].empty?
      warn 'Not part of a Pull Request, so nothing to check in this task'
      next
    end

    if ENV['CI']
      sh 'git fetch origin +master:master 2>/dev/null'
    else
      sh 'git fetch origin master 2>/dev/null'
    end

    modified_files = `git diff --name-only HEAD master`.split("\n")
    puts '---'

    if modified_files.include?('CHANGELOG.md')
      info 'CHANGELOG.md modified.'
      Rake::Task['changelog:check'].invoke
    else
      warn 'Please include an entry in CHANGELOG.md to describe the changes and credit yourself!'
      warn 'Note: use 2 spaces after the last line describing your changes, ' \
                      'then add links to your GitHub account & the PR for attribution'
      exit 1
    end
  end
end

namespace :changelog do
  desc 'Validates the CHANGELOG format'
  task :check do
    previous_type = :empty
    failures = []
    puts 'Linting CHANGELOG.md...'
    File.open('CHANGELOG.md').each_line.with_index do |line, idx|
      line.chomp!
      type = line_type(line)
      case type
      when :li
        failures << [line, idx, 'Please end description lines with a period and 2 spaces'] unless line.end_with?('.  ')
      when :link
        if %i[li link].include?(previous_type)
          failures << [line, idx, 'Please indent links with 2 spaces'] unless line.start_with?('  ')
        end
      end
      previous_type = type
    end
    if failures.empty?
      info 'CHANGELOG.md OK.'
    else
      warn 'Offenses detected:'
      failures.each do |f|
        error '  > ' + f[0]
        error "  Line #{f[1]}: #{f[2]}"
        puts ''
      end
      exit 1
    end
  end
end

## Helper functions ##

# rubocop:disable Metrics/MethodLength
def line_type(line)
  return :empty if line.strip.empty?
  case line
  when /^\#* /
    :header
  when /^\* /
    :li
  when /\[.*\]\(.*\)/
    :link
  else
    :other
  end
end

def info(str)
  puts 'ℹ️' + str
end

def warn(str)
  puts '⚠️ ' + str
end

def error(str)
  puts '🛑 ' + str
end
