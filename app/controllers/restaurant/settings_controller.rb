class Restaurant::SettingsController < ApplicationController
	
	after_filter :rollback_for_sechedule_if_not_admin, :only => [:update_sechedule]
	after_filter :rollback_for_category_if_not_admin, :only => [:update_category]
	after_filter :rollback_for_item_if_not_admin, :only => [:update_item]

	def update_sechedule
		@sechedule = Sechedule.find(params[:id])
		@sechedule.update_attributes(params[:sechedule])
		redirect_to restaurant_dashboard_index_path(:anchor => 'setting')
	end

	def edit_category
		@menu_category = MenuCategory.find(params[:id])
	end

	def update_category
		 @menu_category = MenuCategory.find(params[:id])
    if @menu_category.update_attributes(params[:menu_category])
      redirect_to restaurant_dashboard_index_path(:anchor => 'setting')
    else
      render action: "edit"
    end
	end

	def edit_item
		@restaurant = current_user.restaurants.first
		@menu = @restaurant.menu
		@menu_item = MenuItem.find(params[:id])
	end
	
	def update_item
		@menu_item = MenuItem.find(params[:id])
    if @menu_item.update_attributes(params[:menu_item])
      redirect_to restaurant_dashboard_index_path(:anchor => 'setting')
    else
      render action: "edit"
    end
	end


	def rollback_for_sechedule_if_not_admin
		unless current_user.user_admin?
			version = @sechedule.versions.count
			@sechedule.status = "pending"
			@sechedule.revert_to!(1)
      flash[:notice] = "Your changes will be reflected once an admin has reviewed them"
		end
	end

	def rollback_for_category_if_not_admin
		unless current_user.user_admin?
			version = @menu_category.versions.count
			@menu_category.status = "pending"
			@menu_category.revert_to!(1)
      flash[:notice] = "Your changes will be reflected once an admin has reviewed them"
		end
	end

	def rollback_for_item_if_not_admin
		unless current_user.user_admin?
			version = @menu_item.versions.count
			@menu_item.status = "pending"
			@menu_item.revert_to!(1)
      flash[:notice] = "Your changes will be reflected once an admin has reviewed them"
		end
	end

end
