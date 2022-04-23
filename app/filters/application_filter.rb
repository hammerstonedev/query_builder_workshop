 class ApplicationFilter < Hammerstone::Refine::Filter
  include Hammerstone::Refine::Conditions

  def t(key, options = {})
    # TODO this is failing, removed options temporarily 
    I18n.t("#{self.class.name.gsub(/Filter$/, "").pluralize.underscore}#{key}")
  end

  def initialize(blueprint = nil, initial_query = nil)
    @@default_stabilizer = Hammerstone::Refine::Stabilizers::UrlEncodedStabilizer
    super
  end

  attr_reader :initial_query

  def options_for(field)
    t(".fields.super_select_value.options").map do |key, value|
      {
        id: key.to_s,
        display: value
      }
    end
  end

  def empty_option
    [{id: "null", display: "Empty"}]
  end

  def self.from_state(state, initial_query)
    klass = state[:type].constantize
    klass.new(state[:blueprint], initial_query)
  end

  def translate_display(condition)
    condition.display = condition.id
  end
end
