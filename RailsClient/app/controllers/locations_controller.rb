class LocationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_location, only: [:show, :edit, :update, :destroy, :users, :whouses,:destinations,:add_destination,:remove_destination]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.paginate(:page=> params[:page])#all
    #@locations = @locations.paginate(:page=>params[:page])
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    #@location = Location.new(params.require(:location).permit(:id,:name,:address,:tel))
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: '地点创建成功' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destinations

  end

  def add_destination
    if @location.destinations.include?(Location.find_by_id(location_params[:destination_id]))
      render :destinations
    elsif @location.location_destinations.build({destination_id:location_params[:destination_id]}).save
      redirect_to destinations_location_path(@location), notice: '添加目的地成功'
    else
      render :destinations
    end
  end

  def remove_destination
      d = @location.location_destinations.where({destination_id:params[:destination_id]}).first
      puts d.to_json
      if d.destroy
        render :destinations ,notice: '删除成功'
      else
        render :destinations
      end
  end

  # GET /locations/1/users
  def users
    @users = @location.users.paginate(:page=> params[:page])
  end

  # GET /locations/1/whouses
  def whouses
    @whouses = @location.whouses.paginate(:page=> params[:page])
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      puts '##########################'
      puts location_params
      puts '##########################'
      if @location.update(location_params)
        format.html { redirect_to @location, notice: '地点更新成功.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    if @location.is_base
      respond_to do |format|
        format.html { redirect_to locations_url, notice: '基础地点不可删除.' }
        format.json { head :no_content }
      end
    else
      @location.destroy
      respond_to do |format|
        format.html { redirect_to locations_url, notice: '地点删除成功.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      #params[:location]
      params.require(:location).permit(:name,:address,:tel,:id,:prefix,:suffix,:destination_id)
    end
end
