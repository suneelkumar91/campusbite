module ApplicationHelper

	def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end
      else
        html << "<h5>#{message}</h5>"
      end
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end

  def pending_order
    Order.where(status: "pending").count
  end

  def new_forms_submitted
    JoinUs.where(is_viewed: false).count + RestaurantSuggestion.where(is_viewed: false).count + CampusSuggestion.where(is_viewed: false).count + ContactUs.where(is_viewed: false).count + Subscribe.where(is_viewed: false).count + Support.where(is_viewed: false).count + RedeamRequest.where(is_viewed: false).count + MenuError.where(is_viewed: false).count
  end

  def new_user_sign_up
    User.where(is_viewed: false).count
  end

end
