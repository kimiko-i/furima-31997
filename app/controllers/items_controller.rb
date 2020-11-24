class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @items = Item.all.order("created_at DESC")
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :price, :detail, :category_id, :status_id, :shipping_id, :shipment_day_id, :send_from_id, :image).merge(user_id: current_user.id)
  end
end
