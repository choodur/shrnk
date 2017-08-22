class Link < ApplicationRecord

  validates :original_url, presence: true, uniqueness: true, url: {no_local: true}
  validates :short_url, presence: true, uniqueness: true

  class << self
    def shrink(url)
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
    end

    def generate_short_url
      Base62.encode(Time.now.to_i.to_s.reverse.to_i)
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
end
