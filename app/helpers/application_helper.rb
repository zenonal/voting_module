module ApplicationHelper
  def vote_tally(voteable)
    if (voteable.votes_count>0)
      100*voteable.votes_for/(voteable.votes_for+voteable.votes_against)
    else
      0
    end
  end
  def score_meter(value,size)
    level = ((size*value)-6).to_i
    if level < 0
      level = 0
    end
    output = "<div class=\"meter\">"
    output += image_tag("meter/meter_bkg.png", :size => "#{size}x20", :id => "meter_bkg")
    output += image_tag("meter/meter_front.png", :size => "#{level}x20", :id => "meter_front")
    output += "</div>"
  end
  def title(page_title, show_title = true)
      content_for(:title) { page_title.to_s }
      @show_title = show_title
    end

    def show_title?
      @show_title
    end

    def stylesheet(*args)
      content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
    end

    def javascript(*args)
      args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
      content_for(:head) { javascript_include_tag(*args) }
    end
end
