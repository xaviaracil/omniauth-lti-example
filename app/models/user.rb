class User < ActiveRecord::Base
  attr_accessible :name, :email
  
  def self.find_or_create_from_auth_hash(auth_hash)
    @user = self.find_or_create_by_uid auth_hash['uid'], 
                                       :name => auth_hash.info.name, 
                                       :email => auth_hash.info.email
  end
end
