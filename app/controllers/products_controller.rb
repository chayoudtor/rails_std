class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    if params[:search]
      @products = Product.order(status: :asc, brand: :asc).where("#{params[:option]} LIKE ? ", "%#{params[:search]}%").page(params[:page])
    else
      @products = Product.all.order(status: :asc, brand: :asc).page(params[:page])
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @brands = Brand.all.where(status: "Ongoing")
    if @brands.count(:id) > 0
      @product = Product.new
    else
      redirect_to new_brand_path
    end
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params.merge({"status" => "Available"}))

    @brands = Brand.where(name: @product.brand).take

    logger.debug "Here is value from brand query ; #{@brands.amount_product}"
    respond_to do |format|
      if @product.save
        @brands.update({"amount_product" => @brands.amount_product + 1})
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @brands = Brand.where(name: @product.brand).take
    @product.destroy

    @brands.update({"amount_product" => @brands.amount_product - 1})
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
end
