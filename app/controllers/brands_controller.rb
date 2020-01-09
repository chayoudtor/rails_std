class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # Action for index page
  def index
    @brands = index_page
  end

  # Action for show page
  def show
  end

  # Action for create page
  def new
    @brand = Brand.new
  end

  # Action for edit page
  def edit
  end

  # Action for params that got from new action
  def create
    # Set default amount_product whent created a new brand 
    @brand = Brand.new(brand_params.merge({"amount_product" => 0}))

    # Respond to notice what have done after save action
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

  # Action for params that got from edit action
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

  # Action to close each brand by change there status
  def close
    @brands   = Brand.find(params[:id])
    @products = Product.where(brand: @brands.name)
    @order    = Order.where(brand: @brands.name)

    @brands.update({"status"    => "Closed"})
    @products.update({"status"  => "Close by brand"})
    @order.update({"status"     => "Pending"})
    
    redirect_to brands_path
  end

  # Action to reopen each brand with set child of action
  def reopen
    @brands     = Brand.find(params[:id])
    @products   = Product.all.where(brand: @brands.name)
    @order      = Order.where(brand: @brands.name)

    @brands.update({"status"    => "Pending"})
    @products.update({"status"  => "Wating for confirmation"})
    @order.update({"status"     => "Ordering"})
    
    redirect_to brands_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end

    # Set params to brand environment
    def brand_params
      params.require(:brand).permit(:name, :amount_product, :status)
    end

    # Set action to index page 
    def index_page

      # For search action
      if params[:search] && params[:search] != ""
        Brand.index(sort_column, sort_direction, params[:page], params[:search])
      else
        Brand.index(sort_column, sort_direction, params[:page])
      end
    end

    # Set and get default of column to sort
    def sort_column
      Brand.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    # Set a sort direction between asc and desc
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
