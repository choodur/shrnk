class Link < ApplicationRecord
  VOWELS = %w(a e i o u)
  CHARS = [0..9, 'A'..'Z', 'a'..'z'].flat_map do |range|
    range.map{ |char| VOWELS.include?(char.try(:downcase)) ? nil : char }
  end.compact

  validates :original_url, presence: true, uniqueness: true
  validates :short_url, presence: true, uniqueness: true

  class << self
    def shrink(url)
      link = find_by(original_url: sanitize(url))
      return link if link

      link = new(original_url: url)

      loop do
        link.short_url = generate_short_url
        break unless find_by(short_url: link.short_url)
      end

      link.save
      link
    end

    def generate_short_url
      (1..7).map{ |i| CHARS.sample }.join
    end

    def sanitize(url)

    end
  end
end
