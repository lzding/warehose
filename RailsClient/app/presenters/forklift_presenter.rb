class ForkliftPresenter<Presenter
  Delegators=[:id, :destinationalbe, :created_at, :state, :user_id]
  def_delegators :@forklift, *Delegators

  def initialize(forklift)
    @forklift=forklift
    self.delegators = Delegators
  end

  def destinationalbe_name
    @forklift.destinationalbe.blank? ? '' : @forklift.destinationalbe.name
  end

  def created_at
    @forklift.created_at.blank? ? '' : @forklift.created_at.strftime("%Y-%m-%d %H:%M")
  end

  def user_id
    @forklift.user_id.blank? ? '' : @forklift.user_id
  end

  def sum_packages
    @forklift.sum_packages
  end

  def accepted_packages
    @forklift.accepted_packages
  end

  def all_packages
    packages = []
    pp = PackagePresenter.init_presenters(self.packages)
    pp.each do |p|
      packages << p.to_json
    end
    packages
  end

  def to_json
    {
        id: self.id,
        created_at: self.created_at,
        user_id: self.user_id,
        stocker_id: self.user_id,
        whouse_id: self.destinationalbe
        # sum_packages: self.sum_packages,
        # accepted_packages: self.accepted_packages
    }
  end

  def to_json_with_packages
    {
        id: self.id.to_s,
        created_at: self.created_at,
        user_id: self.user_id,
        stocker_id: self.user_id,
        whouse_id: self.destinationalbe
        # sum_packages: self.sum_packages.to_s,
        # accepted_packages: self.accepted_packages.to_s,
        # packages: self.all_packages
    }
  end
end