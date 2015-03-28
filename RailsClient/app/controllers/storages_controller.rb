class StoragesController < ApplicationController
  before_action :get_whouses, only: [:index, :search]

# GET /deliveries
  def index
    @storages= Storage.joins(:part).paginate(:page => params[:page])
  end

  # def search
  #   @condition=params[@model]
  #   query=model.unscoped
  #   @condition.each do |k, v|
  #     if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
  #       puts @condition.has_key?(k+'_fuzzy')
  #       if @condition.has_key?(k+'_fuzzy')
  #         query=query.where("#{k} like ?", "%#{v}%")
  #       else
  #         query=query.where(Hash[k, v])
  #       end
  #       instance_variable_set("@#{k}", v)
  #     end
  #     if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
  #       values=v.values.sort
  #       values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date?
  #       values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date?
  #       query=query.where(Hash[k, (values[0]..values[1])])
  #       v.each do |kk, vv|
  #         instance_variable_set("@#{k}_#{kk}", vv)
  #       end
  #     end
  #   end
  #   instance_variable_set("@#{@model.pluralize}", query.paginate(:page => params[:page]).all)
  #   render :index
  #
  # end

  private
  def default_query
    Storage.joins(:part)
  end

  def get_whouses
    @whouses=Whouse.all
  end
end
