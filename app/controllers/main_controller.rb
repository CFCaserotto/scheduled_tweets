class MainController < ApplicationController
    def index
      puts "Flash messages: #{flash.inspect}"
    end
  end