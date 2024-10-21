# frozen_string_literal: true

require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/array"

module Rulers
  class Error < StandardError; end

  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {"Content-Type" => "text/html"}, []]
      end
      if env["PATH_INFO"] == "/"
        # klass = Object.const_get('QuotesController')
        # controller = QuotesController.new(env)
        # text = controller.a_quote

        # debugger

        [200, {"Content-Type" => "text/html"}, File.open("public/index.html").readlines]

        # [301, {'Content-Type' => 'text/html', 'Location' => '/quotes/a_quote'}, []]
      else
        klass, act = get_controller_and_action(env)
        controller = klass.new(env)

        begin
          text = controller.send(act)
        rescue
          text = "This is a unique error"
        end

        [200, {"Content-Type" => "text/html"}, [text]]
      end 
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end
end
