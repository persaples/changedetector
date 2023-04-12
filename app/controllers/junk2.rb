require 'nokogiri'
require 'httparty'
require 'diffy'

class UrlChangesController < ApplicationController
  def scrape_url(url)
    response = HTTParty.get(url)
    Nokogiri::HTML(response.body)
  end

  def index
    @url_changes = UrlChange.order(created_at: :desc)
  end

  def create
    url = params[:url]
    content = scrape_url(url).to_s
    url_change = UrlChange.create(url: url, content: content)
    redirect_to url_change_path(url_change)
  end

  def show
    @url_change = UrlChange.find(params[:id])
    @previous_version = UrlChange.where(url: @url_change.url).where('created_at < ?', @url_change.created_at).order(created_at: :desc, id: :desc).first


    if @previous_version.present?
      previous_content = @previous_version.content
      current_content = @url_change.content
      @diff = Diffy::Diff.new(previous_content, current_content, context: 2)
    end
  end
end

