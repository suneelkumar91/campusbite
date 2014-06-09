class Admin::RewardPointsController < ApplicationController

  def index
    page = params[:draw].nil? ? 1 : params[:draw].to_i
    limit = params[:length].to_i
    offset = params[:start].to_i

    unless params[:order].nil?
      col_number = params[:order]["0"]["column"].to_i
      order_by_type  = params[:order]["0"]["dir"]
    end

    attribute_name = get_sort_attribute_name(col_number)
    sorting_query = [attribute_name,order_by_type].join(' ')

    @customers = User.with_orders.offset(offset).limit(limit).order(sorting_query)
    unless params[:search].nil?
      @customers = User.apply_search_filter(@customers, params[:search][:value])
    end
    respond_to do |format|
      format.json do 
        return render :json =>  {draw: page,  recordsTotal: User.count,  recordsFiltered: User.count , :data => @customers.collect{|a| ["<a src='#{admin_reward_point_url(a)}'>#{a.name}</a>",a.points]} }
      end
      format.html
    end
  end

  def show
    @user = User.where(id: params[:id]).first
  end

  private

  def get_sort_attribute_name(column_number)
  
    case column_number
    when 0
      return "first_name"
    else
      return "points"
    end
  end
end
