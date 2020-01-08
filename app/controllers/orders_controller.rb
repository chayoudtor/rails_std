class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    if params[:search] && params[:search] != ""
      @orders = Order.all.search(params[:search]).order(brand: :asc).page(params[:page])
    else
      @orders = Order.all.page(params[:page])
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    logger.debug "Printing debug : #{params[:id]}"
    @products = Product.find(params[:id])
    @order = Order.new({"product" => @products.name, "brand" => @products.brand, "amount" => 1})
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params.merge({"status" => "Ordering"}))
    @order_check = Order.where(product: @order.product, brand: @order.brand).count(:id)

    @history = History.new({"order_code" => SecureRandom.hex, "brand" => @order.brand, "product" => @order.product, "amount" => @order.amount})

    @history.save

    respond_to do |format|
      if @order_check == 0
        if @order.save
          format.html { redirect_to orders_path, notice: 'Order was successfully created.' }
          format.json { render :show, status: :created, location: @order }
        else
          format.html { render :new }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        @order_update = Order.where(product: @order.product, brand: @order.brand).take
        if @order_update.update({"amount" => @order_update.amount + @order.amount})
          format.html { redirect_to @order, notice: 'Order was successfully updated.' }
          format.json { render :show, status: :ok, location: @order }
        else
          format.html { render :edit }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:product, :brand, :amount)
    end
end
