class Link < ApplicationRecord
  VOWELS = %w(a e i o u)
  CHARS = [0..9, 'A'..'Z', 'a'..'z'].flat_map do |range|
    range.map{ |char| VOWELS.include?(char.try(:downcase)) ? nil : char }
  end.compact

  validates :original_url, presence: true, uniqueness: true
  validates :short_url, presence: true, uniqueness: true

  def self.generate_short_url
    (1..7).map{ |i| CHARS.sample }.join
  end

  def shrink
    link = find_by(original_url: original_url)
    return link.short_url if link
    # TODO: check for collision
    short_url = self.class.generate_short_url
  end
end
