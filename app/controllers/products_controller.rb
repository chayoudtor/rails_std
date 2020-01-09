class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # Action for index page
  def index
    @products = index_page
  end

  # Action for show page
  def show
  end

  # Action to new page
  def new

    # Select brand to set select option
    @brands = Brand.all.where(status: "Ongoing")
    
    # Check brand is exist or not 
    if @brands.count(:id) > 0
      @product = Product.new
    else
      redirect_to new_brand_path
    end
  end

  # Action for edit
  def edit
  end

  # Action for params that got from new action
  def create
    
    # Set default status for product
    @product = Product.new(product_params.merge({"status" => "Available"}))

    # Select brand to set amount of product
    @brands = Brand.where(name: @product.brand).take

    # Respond to what have done to notice
    respond_to do |format|
      if @product.save

        # Update number of product to brand
        @brands.update({"amount_product" => @brands.amount_product + 1})

        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # Action for params that got from edit action
  def update
    respond_to do |format|
      if @product.update(product_params)

        # Check updated status of product to update order
        if product_params[:status] == "Out of stock"
          Order.where(product: product_params[:name]).update({"status" => "Sold out"})
        else 
          Order.where(product: product_params[:name]).update({"status" => "Ordering"})
        end

        # Notice update status
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # Action for destroy
  def destroy

    # Select brand related this product
    @brands = Brand.where(name: @product.brand).take

    @product.destroy

    # Update number of product to brand 
    @brands.update({"amount_product" => @brands.amount_product - 1})

    # Respond what have done to notice
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :brand, :status)
    end

    # Set action to index page 
    def index_page

      # For search action 
      if params[:search] && params[:search] != ""
        Product.index(sort_column, sort_direction, params[:page], params[:search])
      else
        Product.index(sort_column, sort_direction, params[:page])
      end
    end

    # Set and get default of column to sort
    def sort_column
      Product.column_names.include?(params[:sort]) ? params[:sort] : "brand"
    end

    # Set a sort direction between asc and desc
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
