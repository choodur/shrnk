class Link < ApplicationRecord

  has_many :visitors

  validates :original_url, presence: true, uniqueness: true, url: {no_local: true}
  validates :short_url, presence: true, uniqueness: true

  class << self
    def shrink(url)
      begin
        link = new(original_url: sanitize(url))

        # 1. check if URL is valid
        opts = {
          attributes: [:original_url],
          no_local: true
        }
        validator = ActiveModel::Validations::UrlValidator.new(opts)
        if validator.validate_each(link, :original_url, link.original_url)
          return link
        end

        # 2. check if taken
        existing_link = find_by(original_url: link.original_url)
        return existing_link if existing_link

        # 3. generate the shortened URL
        link.short_url = generate_short_url

        # we have run the validations before, no need to hit the db again
        link.save(validate: false)
        link
      rescue ActiveRecord::RecordNotUnique => e
        retry
      end
    end

    def generate_short_url
      base = Time.now.to_f.round(5).to_s.split('.').map(&:to_i)
      padding = 99999
      # add gap to lower total value and get lesser characters
      gap = 1_000_000_000
      # add padding so that inclusion of decimals
      # will not collide with next second increment
      result = (base.first + padding - base.last) - gap
      Base62.encode(result.to_s.reverse.to_i)
    end

    private

    def sanitize(url)
      address = url.strip
      return address if address.blank?
      parsed = URI.parse(address)
      # users may input host without scheme which the url validator would treat as invalid
      parsed.scheme.blank? && url.split('.').size > 1 ? "http://#{address}" : address
    rescue URI::InvalidURIError
      address
    end
  end

  def get_visitor_stats_by(attr)
    items = visitors.pluck(attr)
    new_hash = Hash.new{ |k, v| k[v] = 0}
    items.reduce(new_hash) do |hash, item|
      key = item.nil? ? 'None' : item
      hash[key] += 1
      hash
    end
  end
end
