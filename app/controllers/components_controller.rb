class ComponentsController < ApplicationController
  layout 'brand'
  before_action :set_component, only: [:show, :edit, :update, :destroy]

  # GET /components
  def index
    @components = Component.all
  end

  # GET /components/1
  def show
  end

  # GET /components/new
  def new
    @component = Component.new
  end

  # GET /components/1/edit
  def edit
  end

  # POST /components
  def create
    @component = Component.new(component_params)

    if @component.save
      redirect_to @component, success: 'Component was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /components/1
  def update
    if @component.update(component_params)
      redirect_to @component, success: 'Component was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /components/1
  def destroy
    @component.destroy
    redirect_to components_url, success: 'Component was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_component
      @component = Component.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def component_params
      params.require(:component).permit(:brand_id, :name, :description, :markup, :style)
    end
end
