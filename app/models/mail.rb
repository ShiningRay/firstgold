class Mail < ActiveRecord::Base
  belongs_to :owner, :class_name => 'Character'
  belongs_to :sender, :class_name => 'Character'  
  belongs_to :recipient, :class_name => 'Character'  
end
