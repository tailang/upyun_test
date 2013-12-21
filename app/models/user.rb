class User < ActiveRecord::Base
  attr_accessible :avatar, :name, :avatar_cache
  attr_accessor :upload_secure_token
  mount_uploader :avatar, AvatarUploader
end
