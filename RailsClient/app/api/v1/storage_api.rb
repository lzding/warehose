module V1
  class StorageAPI<Base
    namespace :storages

    post :move_store do
      ActiveRecord::Base.transaction do
        if forklift=Forklift.exists?(params[:id])
          if fsc=forklift.store_containers.where(source_location_id: current_user.location_id).first
            fsc_destination=nil
            fsc.descendants.joins(:package).each do |psc|
              destination=psc.destinationable
              psc.move_store(destination)
              fsc_destination=destination
            end
            fsc.move_store(fsc_destination)
          else
            return {result: 0, content: '还未入库！'}
          end
        else
          return {result: 0, content: ForkliftMessage::NotExit}
        end
      end
    end
  end
end
