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

namespace :pr do
  desc 'Check incoming PRs on CI'
  task :check do
    modified_files = `git diff --name-only master`.split("\n")

    if modified_files.include?('CHANGELOG.md')
      Rake::Task['changelog:check'].invoke
    else
      puts 'Please include an entry in CHANGELOG.md to describe the changes and credit yourself!'
      puts 'Note: use 2 spaces after the last line describing your changes, ' \
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
    unless failures.empty?
      failures.each do |f|
        puts '> ' + f[0]
        puts "Line #{f[1]}: #{f[2]}"
      end
      exit 1
    end
  end
end
