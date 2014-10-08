class OrderItem < ActiveRecord::Base
	include Extensions::UUID

	belongs_to :order
	belongs_to :user
	belongs_to :location
	belongs_to :whouse
	#belongs_to :source, class_name: "Location"
	belongs_to :part
	belongs_to :part_type
  has_many :pick_items

  after_create :led_state_change

  def led_state_change
    puts 'order item created...........'
    pp = OrderItemService.verify_department(self.whouse_id,self.part_id)
    if pp.nil?
      return
    end
    puts 'position...........'
    LedService.update_led_state_by_position(pp.position.detail,LedLightState::ORDERED)
=begin
    led = Led.find_by_position(position.detail)
    to_state = LedLightState::ORDERED
    if led.current_state != to_state
      led.update({current_state:to_state})
    end
=end
  end

  def generate_id
    "OI#{Time.now.to_milli}"
  end

  def state
    if self.out_of_stock
      '缺货'
    elsif self.is_finished
      '完成备货'
    else
      '未处理'
    end
  end
end
