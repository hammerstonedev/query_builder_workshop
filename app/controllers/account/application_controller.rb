class Account::ApplicationController < ApplicationController
  include Account::Controllers::Base

  def ensure_onboarding_is_complete
    # First check that Bullet Train doesn't have any onboarding steps it needs to enforce.
    return false unless super

    # Most onboarding steps you'll add should be skipped if the user is adding a team or accepting an invitation ...
    unless adding_team? || accepting_invitation?
      # So, if you have new onboarding steps to check for an enforce, do that here:
    end

    # Finally, if we've gotten this far, then onboarding appears to be complete!
    true
  end

  def child_filter_class
    # e.g. `Scaffolding::CompletelyConcrete::TangibleThingsFilter`
    self.class.name.gsub(/^Account::/, "").gsub(/Controller$/, "Filter").constantize
  rescue NameError => _
    nil
  end

  def apply_filter(current_scope = nil)
    if child_filter_class.present?
      @stored_filter = nil
      # @stored_filter = Hammerstone::Refine::StoredFilter.find_by(id: stored_filter_id)
      @stable_id = stable_id
      @refine_filter = if stable_id
        Hammerstone::Refine::Stabilizers::UrlEncodedStabilizer.new.from_stable_id(id: stable_id, initial_query: @parent_object.send(@child_collection))
      elsif @stored_filter
        @stored_filter.refine_filter
      else
        # e.g. `Scaffolding::CompletelyConcrete::TangibleThingsFilter`
        child_filter_class.new([], @parent_object.send(@child_collection))
      end
      # e.g. `@tangible_things = @refine_filter.get_query`
      # TODO We should also make it the expectation at a framework level that when we do this, we also update some type
      # of generically named instance variable like @child_collection, except right now that's just a symbol. The idea
      # here is that any other "plugins" or magic behavior like this should compound and play well with each other.
      instance_variable_set(children_instance_variable_name, @refine_filter.get_query)

      # This takes a current scope from tab, etc and merges it in
      instance_variable_set(children_instance_variable_name, children_instance_variable.merge(current_scope)) if current_scope
    end
  end


  def filter_params
    # The filter can come in as a stored_filter_id (database stabilized) or a stable_id (url encoded)
    params.permit(:filter, :stable_id, :blueprint, :conditions, :clauses, :name, :tab, :site_id, :workspace_id, :product_id, :q, :stored_filter_id)
  end

  def stored_filter_id
    filter_params[:stored_filter_id]
  end

  def stable_id
    filter_params[:stable_id]
  end

  
  def children_instance_variable_name
    # e.g. `tangible_things`
    "@" + self.class.name.gsub(/^Account::/, "").gsub(/Controller$/, "").split("::").last.underscore
  end

  def children_instance_variable
    instance_variable_get(children_instance_variable_name)
  end

end
