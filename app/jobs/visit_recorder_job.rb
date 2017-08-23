class VisitRecorderJob
  include SuckerPunch::Job

  def perform(link_id, remote_ip, user_agent)
    visitor = Visitor.parse(remote_ip, user_agent)
    link = Link.find(link_id)
    link.visitors << visitor
  end
end
