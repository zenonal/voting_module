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
        def bill_progression(bill)
                passedColor = "#A19EA0"
                futureColor = "#B6CCB5"
                editColor = futureColor
                validationColor = futureColor
                amendColor = futureColor
                voteColor = futureColor
                if !bill.blank?
                       if bill.current_phase >= 2
                               editColor = passedColor
                       end
                       if bill.current_phase >= 3
                               validationColor = passedColor
                       end
                       if bill.current_phase >= 4
                               amendColor = passedColor
                       end
                       if bill.current_phase >= 5
                               voteColor = passedColor
                       end
                end
                if !bill.blank? && bill.current_phase < 5
                        output = ""
                        output += "<div style=\"width:100px;margin:auto;position:static;\">"
                        output += "<div style=\"width:100px; height:10px; background-color:" + voteColor + ";\">"
                        output += "<div style=\"width:77%; height:10px; background-color:" + amendColor + "; border-right:2px #FFF solid;\">"
                        output += "<div style=\"width:70%; height:10px; background-color:" + validationColor + "; border-right:2px #FFF solid;\">"
                        output += "<div style=\"width:14%; height:10px; background-color:" + editColor + "; border-right:2px #FFF solid;\">"
                        output += "</div></div></div></div></div>"
                end
        end
        def title(page_title, show_title = true)
                if page_title
                        content_for(:title) { t('layout.page_title') + ' - ' + page_title.to_s }
                else
                        content_for(:title) { t('layout.page_title') }
                end
                if show_title
                        raw "<h1>#{page_title}</h1>"
                end
        end

        def info_help(id,size=20)
                if cookies[:info_active] == "true"
                        output="<span class=\"info_help\">"
                        output+=image_tag("i.png",:size => "#{size}x#{size}", :class => "info_help_img", :title=> t("info.#{id}"))
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

        def main_root
                unless ENV['RAILS_ENV']=="production" 
                        return root_url(:protocol => "http", :host => "#{request.domain}#{request.port_string}")
                else
                        return root_url(:protocol => "http", :host => "#{request.domain}#{request.port_string}")
                end
        end

end
