require 'digest/md5'

class User < ActiveRecord::Base
  validates_uniqueness_of :username
  validates_presence_of :username

  def update_attributes(params)
    if params[:password] == ''
      params[:password] = self.password
    else
      params[:password] = '{md5} ' + Digest::MD5.hexdigest(params[:username] + '^' + params[:password])
    end
    return false unless super(params)
    true
  end

  def save
    if self.password.first != '{'
      self.password = '{md5} ' + Digest::MD5.hexdigest(self.username + '^' + self.password)
    end
    super
  end

  def self.authenticate(params)
    self.find_by_login(params)
  end

  def self.find_by_login(params)
    username = params[:username]
    pass = '{md5} ' + Digest::MD5.hexdigest("#{params[:username]}^#{params[:password]}")
    if user = User.find(:first, :conditions => ["username = ? and password = ? and active = 1", params[:username], pass])
      user
    else
      false
    end
  end

end
