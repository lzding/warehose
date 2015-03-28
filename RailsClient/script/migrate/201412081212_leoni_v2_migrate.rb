puts "开始更新用户......"
user_count = 0
User.all.each do |u|
  if u.user_name.nil?
    u.update({user_name: u.id})
    user_count+=1
  end
end
puts user_count.to_s+"个User被更新"

Location.all.each do |l|
  if l.destination_id && (l.location_destinations.where(destination_id: l.destination_id).count == 0)
    ld = l.location_destinations.build({location_id: l.id, destination_id: l.destination_id, is_default: true})
    ld.save
    puts "-----------------"
    puts ld.destination.name
  end
end
puts "结束更新用户......"

puts "开始更新正则......"
Regex.all.each { |reg|
  reg.update({id: reg.code})
}

RegexType.types.each do |type|
  if RegexCategory.where(id: type, name: RegexType.display(type), type: type).count == 0
    rc=RegexCategory.new(id: type, name: RegexType.display(type), type: type)
    Regex.where(type: type).each do |r|
      rc.regexes<<r
    end
    rc.save
  end
end
puts "结束更新正则......"

puts "开始迁移要货单......"
Order.all.each do |o|
  o.update(source_location_id: o.user.location_id)
end
OrderItem.all.each do |oi|
  if oi.is_finished
    oi.update(state: OrderItemState::FINISHED,is_dirty:false)
  elsif oi.out_of_stock
    oi.update(state: OrderItemState::OUT_OF_STOCK,is_dirty:false)
  else
    oi.update(state: OrderItemState::INIT,is_dirty:false)
  end
end
puts "结束迁移要货单......"

=begin
puts "开始更新零件......"
dump_pos_count = 0
update_pos_count = 0
Position.all.each do |p|
  id = "PS#{p.whouse_id}#{p.detail.gsub(/\s+/, '')}"

  olds = Position.unscoped.where(id: id)
  #puts "#{olds.count},#{id}"

  if olds.count > 0
    dump_pos_count += olds.count
    olds.each do |o|
      o.update({id: SecureRandom.uuid, is_delete: true})
    end
  end
  update_pos_count += 1
  ActiveRecord::Base.transaction do
    p.part_positions.each { |pp| pp.update({position_id: id}) }
    p.update({id: id, is_delete: false})
  end
end

puts "删除了#{dump_pos_count}个重复库位!更新了#{update_pos_count}个库位!"
puts "结束更新零件......"

#update part_position
dump_pos_count = 0
update_pos_count = 0
puts "开始更新零件库位......"
PartPosition.all.each do |pp|
  id = "#{pp.part_id}#{pp.position_id}"

  olds = PartPosition.unscoped.where(id: id)
  #puts "#{olds.count},#{id}"

  if olds.count > 1
    dump_pos_count += olds.count
    olds.each { |o|
      o.update({id: SecureRandom.uuid, is_delete: true})
    }
  end
  update_pos_count += 1
  if pp.position.nil?
    pp.update({id: id, is_delete: true})
  else
    pp.update({id: id, is_delete: false})
  end

end
puts "删除了#{dump_pos_count}个重复零件库位!更新了#{update_pos_count}个零件库位!"
puts "零件库位结束更新......"
=end