class StoreContainer<LocationContainer
  include CZ::Containable
  default_scope { where(type: LocationContainerType::STORE) }
  has_ancestry
  belongs_to :package, foreign_key: :container_id

  before_create :init_container_state

  def init_container_state
    self.state=StorableState::INIT
  end

  def in_store(storable)
    if self.can_in_store?
      c=self.container
      c.current_positionable=storable
      self.state=StorableState::INSTORE
      c.save
      self.save

      if part=c.part
        unless s=part.storages.where(storable: storable).first
          s=part.storages.build(quantity: c.quantity)
          s.storable=storable
        else
          s.quantity+=c.quantity
        end
        s.save
      end
    end
  end

  def move_store(destination)
    c=self.container
    if part=c.part
      if ss=part.storages.where(storable: c.current_positionable).first
        ss.quantity-=c.quantity
        ss.save
      end
      if ds=part.storages.where(storable: destination).first
        ds.quantity+=c.quantity
      else
        ds=part.storages.build(quantity: c.quantity)
        ds.storable=destination
      end
      ds.save
    end
    c.current_positionable=destination
    c.save
  end

  def cancel_store
    if self.can_cancel_store?
      c=self.container
      if  part=c.part
        if s=part.storages.where(storable: c.current_positionable).first
          s.quantity=0
          s.save
        end
      end
      c.current_positionable=nil
      c.save
    end
  end

  def self.out_store_by_container(container, location_id)
    if (sc=container.store_containers.where(source_location_id: location_id).first) && (part=container.part)
      if s=part.storages.where(storable: container.current_positionable).first
        s.quantity-=container.quantity
        s.save
        sc.update(state: StorableState::OUTSTORE)
        container.current_positionable=nil
      end if sc.can_out_store?
    end
  end

  def can_in_store?
    self.state==StorableState::INIT
  end

  def can_cancel_store?
    self.state==StorableState::INSTORE
  end

  def can_move_store?(destination)
    self.container.current_positionable !=destination && self.state== StorableState::INSTORE
  end

  def can_out_store?
    self.state==StorableState::INSTORE
  end
end
