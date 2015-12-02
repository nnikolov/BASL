require 'digest/md5'

class User < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :username, :presence => true, :uniqueness => true

  #attr_accessible :name, :username, :email

  def update_attributes(params, credentials)
    logged_in = User.find_by_login(credentials)
    return false unless super(params)
    self.updated_by_id = logged_in.id
    if params[:password] != '' and logged_in.active and (logged_in.admin or self.username == credentials[:username])
      self.set_password(params[:password])
    end
    if logged_in.admin and logged_in.active
      self.admin = params[:admin]
      self.active = params[:active]
    end
    self.save
  end

  def set_password(password)
    self.password = User.encrypt_password(self.username, password)
    self.save
  end

  def self.authenticate(params)
    self.find_by_login(params)
  end

  def self.find_by_login(params)
    pass = self.encrypt_password(params[:username], params[:password])
    #if user = User.find(:first, :conditions => ["username = ? and password = ? and active = ?", params[:username], pass, true])
    if user = User.where(["username = ? and password = ? and active = ?", params[:username], pass, true]).first
      user
    else
      false
    end
  end

  private

  def self.encrypt_password(username, password)
    '{md5} ' + Digest::MD5.hexdigest(username + '^' + password)
  end
end
