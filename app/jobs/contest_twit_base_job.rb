class ContestTwitBaseJob < BaseJob
  @queue = :twit

  def self.post_for(subject, contest)
    I18n.t(subject,
           :scope => [:twit],
           :name  => contest.name,
           :url   => contest_url(contest),
           :start => contest.start,
           :end   => contest.end)
  end

  def self.contest_url(contest)
    Rails.application.routes.url_helpers.contest_url(contest)
  end
end
