class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # Action for index
  def index
    @orders = index_page
  end

  # Action for show
  def show
  end

  # Action for new
  def new
    logger.debug "Printing debug : #{params[:id]}"
    @products = Product.find(params[:id])
    @order = Order.new({"product" => @products.name, "brand" => @products.brand, "amount" => 1})
  end

  # Action for edit
  def edit
  end

  # Action for params that got from new
  def create

    # Set default status to new order
    @order = Order.new(order_params.merge({"status" => "Ordering"}))

    # Check duplicate of order from product
    @order_check = Order.where(product: @order.product, brand: @order.brand).count(:id)

    # Update history after request new order
    @history = History.new({"order_code" => SecureRandom.hex, "brand" => @order.brand, "product" => @order.product, "amount" => @order.amount})

    @history.save

    respond_to do |format|

      # Order duplication check
      if @order_check == 0

        # Set notice after order save action
        if @order.save
          format.html { redirect_to orders_path, notice: 'Order was successfully created.' }
          format.json { render :show, status: :created, location: @order }
        else
          format.html { render :new }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        # Select exist order to update amount
        @order_update = Order.where(product: @order.product, brand: @order.brand).take

        # Set notice after order update action
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

   # Action for params that got from edit
  def update

    # Set notice after update action
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

  # Action for destroy
  def destroy
    @order.destroy

    # Set notice after destroy action
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

    # Set action to index page 
    def index_page

      # For search action 
      if params[:search] && params[:search] != ""
        Order.index(sort_column, sort_direction, params[:page], params[:search])
      else
        Order.index(sort_column, sort_direction, params[:page])
      end
    end

    # Set and get default of column to sort
    def sort_column
      Order.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
    end

    # Set a sort direction between asc and desc
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
