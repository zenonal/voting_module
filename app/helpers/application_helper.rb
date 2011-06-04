module ApplicationHelper
  def vote_tally(voteable)
    if (voteable.votes_count>0)
      100*voteable.votes_for/(voteable.votes_for+voteable.votes_against)
    else
      0
    end
  end
  def vote_options(voter,voteable)
    output = "<table><tr><td>"
    if voter.voted_for?(voteable)
			output += link_to("aye", {:controller => :referendums, :action => :aye, :id => voteable.id, :delegated => true}, :class => 'aye bill_support')
		else
			output += link_to("aye", {:controller => :referendums, :action => :aye, :id => voteable.id, :delegated => true}, :class => 'aye bill_nosupport')
	  end
		output +=	"</td><td>"
		if voter.voted_against?(voteable)
			output += link_to("nay", {:controller => :referendums, :action => :nay, :id => voteable.id, :delegated => true}, :class => 'nay bill_support')
		else
			output += link_to("nay", {:controller => :referendums, :action => :nay, :id => voteable.id, :delegated => true}, :class => 'nay bill_nosupport')
	  end
	  output += "</td></tr></table>"
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
      if show_title
        raw "<h2>#{page_title}</h2>"
      end
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
