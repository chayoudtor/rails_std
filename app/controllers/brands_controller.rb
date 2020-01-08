class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /brands
  # GET /brands.json
  def index
    if params[:search]
      @brands = Brand.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page])
    else
      @brands = Brand.all.order(sort_column + " " + sort_direction).page(params[:page])
    end
  end

  # GET /brands/1
  # GET /brands/1.json
  def show
  end

  # GET /brands/new
  def new
    @brand = Brand.new
  end

  # GET /brands/1/edit
  def edit
  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(brand_params.merge({"amount_product" => 0}))

    respond_to do |format|
      if @brand.save
        format.html { redirect_to @brand, notice: 'Brand was successfully created.' }
        format.json { render :show, status: :created, location: @brand }
      else
        format.html { render :new }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brands/1
  # PATCH/PUT /brands/1.json
  def update
    respond_to do |format|
      if @brand.update(brand_params)
        format.html { redirect_to @brand, notice: 'Brand was successfully updated.' }
        format.json { render :show, status: :ok, location: @brand }
      else
        format.html { render :edit }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.json
  # def destroy
  #   @brand.destroy
  #   respond_to do |format|
  #     format.html { redirect_to brands_url, notice: 'Brand was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  def close
    @brands = Brand.find(params[:id])
    @products = Product.all.where(brand: @brands.name)

    @brands.update({"status" => "Closed"})
    @products.update({"status" => "Close by brand"})
    
    redirect_to brands_path
  end

  def reopen
    @brands = Brand.find(params[:id])
    @products = Product.all.where(brand: @brands.name)

    @brands.update({"status" => "Pending"})
    @products.update({"status" => "Wating for confirmation"})
    
    redirect_to brands_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      params.require(:brand).permit(:name, :amount_product, :status)
    end

    def sort_column
      Brand.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
