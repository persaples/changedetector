def show
  @url_change = UrlChange.find(params[:id])
  @previous_version = UrlChange.where(url: @url_change.url).where('created_at < ?', @url_change.created_at).order(created_at: :desc).first

  if @previous_version.present?
    previous_content = @previous_version.content
    current_content = @url_change.content
    @diff = Diffy::Diff.new(previous_content, current_content, context: 2)

    # Get the changes as an array of lines, with added and removed lines marked with a prefix
    changes = @diff.to_a.map do |line|
      case line[0]
      when '+'
        "<ins>#{line}</ins>"
      when '-'
        "<del>#{line}</del>"
      else
        line
      end
    end

    # Join the lines back into a string and remove any HTML tags
    @changes_html = changes.join("\n").gsub(/<\/?[^>]*>/, '')

    # Highlight the added and removed words using CSS
    @changes_html = @changes_html.gsub(/<ins>(.*?)<\/ins>/, '<span class="added">\1</span>')
    @changes_html = @changes_html.gsub(/<del>(.*?)<\/del>/, '<span class="removed">\1</span>')
  end
end
