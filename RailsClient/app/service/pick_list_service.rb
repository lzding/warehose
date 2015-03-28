class PickListService
  def self.covert_order_to_pick_list user_id, order_ids
    order_items=PickItemService.get_order_items(user_id, order_ids)
    if order_items && order_items.count>0
      pick_list=PickList.new(user_id: user_id,order_ids:order_ids.join(';'))
      order_items.each do |i|
        pick_list.pick_items<<PickItem.new(
            quantity: i.quantity,
            box_quantity: i.box_quantity,
            destination_whouse_id: i.whouse_id,
            user_id: i.user_id,
            part_id: i.part_id,
            part_type_id: i.part_type_id,
            remark: i.remark,
            is_emergency: i.is_emergency,
            order_item_id: i.id
        )
        i.update(handled:true)
      end
      remark = ""
      OrderService.find({id:order_ids}).each do |o|
        o.update(status:OrderState::PRINTED)
        remark+= o.remark
      end
      pick_list.remark = remark
      pick_list.save
      return pick_list
    end
  end

  #-------------
  #find_by_days
  #params
  #@user
  #@days = 3
  #-------------
  def self.find_by_days user,days=3
    start_t = 3.day.ago.at_beginning_of_day.utc
    end_t = Time.now.at_end_of_day.utc
    condition = {
        :created_at => start_t..end_t,
        :user_id => user.id,
    }
    PickList.where(condition).all.order(created_at: :desc)
  end
end