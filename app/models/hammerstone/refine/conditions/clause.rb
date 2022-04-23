module Hammerstone::Refine::Conditions
  class Clause

    attr_reader :id
    attr_accessor :display

    def initialize(id = nil, display = nil)
      @id = id
      @display = display || id.humanize(keep_id_suffix: true).titleize
    end

    def to_array
      {
        id: @id,
        display: @display,
        meta: meta
      }
    end

    def meta
      @meta ||= {}
    end
    
  end
end
