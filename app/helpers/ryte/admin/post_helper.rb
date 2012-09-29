module Ryte::Admin::PostHelper

  def friendly_date(time)
    if time.today?
      "#{time_ago_in_words(time)} ago"
    elsif time.year == Time.now.year
      time.strftime("%a %b %e %l:%M%P")
    elsif
      time.strftime("%a %b %e %l:%M %Y")
    end
  end
end

