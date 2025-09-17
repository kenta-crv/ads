module Api
  module V1
    class EmbedController < ApplicationController
      def show
        response.headers["Content-Type"] = "application/javascript"
        render "api/v1/embed/show.js.erb"
      end
    end
  end
end
