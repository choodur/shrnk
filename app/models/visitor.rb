class Visitor < ApplicationRecord
  belongs_to :link, counter_cache: true

  def self.parse(remote_ip, user_agent)
    visitor = new
    visitor.get_browser_details(user_agent)
    visitor.get_visitor_details(remote_ip)
    visitor
  end

  def get_browser_details(user_agent)
    agent = UserAgent.parse(user_agent)
    self.os = agent.os
    self.browser = agent.browser
    self.browser_version = agent.version.to_s
  end

  def get_visitor_details(remote_ip)
    address = MaxMind.lookup(remote_ip)
    self.ip = remote_ip
    self.city = address.city.name
    self.country = address.country.iso_code
  end
end
