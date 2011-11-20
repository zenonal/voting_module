module ApplicationHelper
  def vote_options(voter,voteable)
    del = (voter.class.name == "Delegate")
    output = "<ul class=\"horiz-list\"><li>"
    if voter.voted_for?(voteable)
			output += link_to("aye", {:controller => voteable.class.name.pluralize.downcase, :action => :aye, :id => voteable.id, :delegated => del}, :class => 'aye bill_support', :remote => true)
		else
			output += link_to("aye", {:controller => voteable.class.name.pluralize.downcase, :action => :aye, :id => voteable.id, :delegated => del}, :class => 'aye bill_nosupport', :remote => true)
	  end
	  output += "</li><li>"
		if voter.voted_against?(voteable)
			output += link_to("nay", {:controller => voteable.class.name.pluralize.downcase, :action => :nay, :id => voteable.id, :delegated => del}, :class => 'nay bill_support', :remote => true)
		else
			output += link_to("nay", {:controller => voteable.class.name.pluralize.downcase, :action => :nay, :id => voteable.id, :delegated => del}, :class => 'nay bill_nosupport', :remote => true)
	  end
	  output += "</li></ul>"
  end
  def score_meter(value,size)
    level = ((size*value)-6).to_i
    if level < 0
      level = 0
    end
    output = "<div class=\"meter\">"
    output += image_tag("meter/meter_bkg.png", :size => "#{size}x#{(size/5).round()}", :class => "meter_bkg")
    output += image_tag("meter/meter_front.png", :size => "#{level}x#{(size/5).round()}", :class=> "meter_front")
    output += "</div>"
  end
  def title(page_title, show_title = true)
      content_for(:title) { page_title.to_s }
      if show_title
        raw "<h2>#{page_title}</h2>"
      end
    end
    
    def info_help(id,size=20)
            if cookies[:info_active] == "true"
                    output="<span class=\"info_help\">"
                    output+=image_tag("i.png",:size => "#{size}x#{size}", :class => "info_help_img", :title=>t("info.#{id}"))
                    output+="</span>"
                    output = raw(output)
            else
                    output = ""
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
  
  def humanize_duration(duration)
    output = ""
    output += pluralize(duration.to_i/(24*60*60), t(:days))
    output += ", "
    output += pluralize(duration.to_i/(60*60)%24, t(:hours)) 
    output += ", "
    output += pluralize(duration.to_i/(60)%60, t(:minutes))
  end
  
end
