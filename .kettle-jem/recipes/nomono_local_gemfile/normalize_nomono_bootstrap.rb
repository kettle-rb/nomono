# frozen_string_literal: true

comment_paragraph = lambda do |paragraph|
  lines = paragraph.lines
  !lines.empty? && lines.all? { |line| line.lstrip.start_with?("#") }
end

dedupe_bootstrap_preamble = lambda do |text, local_bootstrap|
  before_bootstrap, after_bootstrap = text.split(local_bootstrap, 2)
  next text unless after_bootstrap

  prefix = before_bootstrap.sub(/\n+\z/, "")
  paragraphs = prefix.split(/\n{2,}/).reject(&:empty?)
  next text if paragraphs.length < 2

  deduped_paragraphs = paragraphs.dup
  ((paragraphs.length / 2)).downto(1) do |sequence_length|
    leading_count = paragraphs.length - (sequence_length * 2)
    next if leading_count.negative?

    first_sequence = paragraphs[leading_count, sequence_length]
    second_sequence = paragraphs[leading_count + sequence_length, sequence_length]
    next unless first_sequence == second_sequence

    deduped_paragraphs = paragraphs[0, leading_count + sequence_length]
    break
  end

  next text if deduped_paragraphs == paragraphs

  rebuilt = +""
  rebuilt << deduped_paragraphs.join("\n\n")
  rebuilt << "\n\n" unless rebuilt.empty?
  rebuilt << local_bootstrap
  rebuilt << after_bootstrap
  rebuilt
end

lambda do |content:, **|
  local_bootstrap = 'require_relative "../../lib/nomono/bundler"'
  plain_bootstrap = 'require "nomono/bundler"'

  return content unless content.include?(local_bootstrap)

  stripped_lines = []
  content.each_line do |line|
    stripped_lines << line unless line.strip == plain_bootstrap
  end

  normalized = stripped_lines.join.gsub(/\n{3,}/, "\n\n")
  normalized = dedupe_bootstrap_preamble.call(normalized, local_bootstrap)
  paragraphs = normalized.split(/\n{2,}/)

  deduped = paragraphs.each_with_object([]) do |paragraph, memo|
    next if paragraph.empty?
    next if comment_paragraph.call(paragraph) && paragraph == memo.last

    memo << paragraph
  end

  result = deduped.join("\n\n")
  result << "\n" unless result.empty? || result.end_with?("\n")
  result
end
