class ItemsController < ApplicationController
  def index
    # @items = Item.all
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

  private

  def item_params
    params.require(:item).permit(:name, :price, :detail, :category_id, :status_id, :shipping_id, :shipment_day_id, :send_from_id, :image).merge(user_id: current_user.id)
  end
end
