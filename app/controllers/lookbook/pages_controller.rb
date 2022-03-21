module Lookbook
  class PagesController < ApplicationController
    def self.controller_path
      "lookbook/pages"
    end

    def index
      landing = Lookbook.pages.find(&:landing) || Lookbook.pages.first
      if landing.present?
        redirect_to page_path landing.lookup_path
      else
        render "not_found"
      end
    end

    def show
      @pages = Lookbook.pages
      @page = @pages.find_by_path(params[:path])
      if @page
        @page_content = page_controller.render_page(@page)
        @next_page = @pages.find_next(@page)
        @previous_page = @pages.find_previous(@page)
      else
        render "not_found"
      end
    end

    protected

    def page_controller
      controller_class = Lookbook.config.page_controller.constantize
      controller = controller_class.new
      controller.request = request
      controller
    end
  end
end
