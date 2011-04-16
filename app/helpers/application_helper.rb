module ApplicationHelper
  def vote_tally(voteable)
    100*voteable.votes_for/(voteable.votes_for+voteable.votes_against)
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
