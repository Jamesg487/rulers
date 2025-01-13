# frozen_string_literal: true

require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/array"
require "rulers/controller"
require "rulers/file_model"

module Rulers
  def self.framework_root
    __dir__
  end

  class Error < StandardError; end

  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      # debugger

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      controller.set_action(act)
      text = controller.send(act)
      r = controller.get_response

      if r
        [r.status, r.headers, [r.body].flatten]
      else
        [200, {'Content-Type' => 'text/html'}, [text]]
      end
    end
  end
end
