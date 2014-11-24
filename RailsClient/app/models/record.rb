class Record < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :recordable, polymorphic: true
  belongs_to :destinationable, polymorphic: true
  belongs_to :impl, class_name: 'User'

  def self.update_or_create(recordable,impl,destinationable=nil)
    unless mr = self.where({recordable:recordable,impl_action: impl["action"]}).first
      self.create({destinationable:destinationable,recordable:recordable,impl_id:impl['id'],impl_user_type:impl['type'],impl_action:impl['action'],impl_time:Time.now})
    else
      mr.update({impl_id:impl['id'],impl_user_type:impl['type'],impl_time:Time.now})
    end
  end

  def display
    "#{ImplUserType.display(self.impl_user_type)} #{self.impl.name}|#{self.impl_id} 在 #{self.impl_time.localtime.strftime('%Y.%m.%d %H:%M')} #{self.impl_action}"
  end
end
