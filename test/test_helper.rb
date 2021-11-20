ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  fixtures :all

  #テストユーザーがログイン中の場合にtrue sessions_helperの中のlogged_in?はテストから呼び出せないので定義
  def is_logged_in?
    !session[:user_id].nil?
  end

end
