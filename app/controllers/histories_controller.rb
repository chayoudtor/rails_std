class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # Action for index page
  def index
    @histories = index_page
  end

  # Action for show page
  def show
  end

  # Action for new page
  def new
    @history = History.new
  end

  # Action for edit page 
  def edit
  end

  # Action for params that got from new action
  def create
    @history = History.new(history_params)

    # Respond to notice what have done after create
    respond_to do |format|
      if @history.save
        format.html { redirect_to @history, notice: 'History was successfully created.' }
        format.json { render :show, status: :created, location: @history }
      else
        format.html { render :new }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # Action for params that got from edit action 
  def update

    # Respond to notice what have done after edit
    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to @history, notice: 'History was successfully updated.' }
        format.json { render :show, status: :ok, location: @history }
      else
        format.html { render :edit }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # Action for destroy
  def destroy
    @history.destroy

    # Respond to notice what have done after destroy
    respond_to do |format|
      format.html { redirect_to histories_url, notice: 'History was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Action for clear all histories
  def clear
    History.all.destroy_all

    # Respond to notic what have done after clear
    respond_to do |format|
      format.html { redirect_to histories_path, notice: 'History was successfully clear.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_history
      @history = History.find(params[:id])
    end

    # Set params to histories environment
    def history_params
      params.require(:history).permit(:order_code, :brand, :product, :amount)
    end

    # Set action to index page 
    def index_page

      # For search action 
      if params[:search] && params[:search] != ""
        History.index(sort_column, sort_direction, params[:page], params[:search])
      else
        History.index(sort_column, sort_direction, params[:page])
      end
    end

    # Set and get default of column to sort
    def sort_column
      History.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    # Set a sort direction between asc and desc
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
