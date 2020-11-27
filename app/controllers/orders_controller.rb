class OrdersController < ApplicationController
  before_action :set_order
  before_action :authenticate_user!

  def index
    if @item.order.present? && @item.user_id == current_user.id
      redirect_to root_path
    end
    @purchase_form = PurchaseForm.new  
  end

  def create
    @purchase_form = PurchaseForm.new(purchase_params)
    if @purchase_form.valid?
      pay_item
      @purchase_form.save
      return redirect_to root_path
    else
      render :index
    end
  end

  private

  def purchase_params
    params.require(:purchase_form).permit(:postal_code, :prefecture_id, :city, :house_number,
                                          :building_name, :tel, :token)
                                          .merge(token: params[:token], user_id: current_user.id, item_id: params[:item_id])
  end 

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: @item.price,
      card:   purchase_params[:token],
      currency: 'jpy'
    ) 
  end

  def set_order
    @item = Item.find(params[:item_id])
  end  

end