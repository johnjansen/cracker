module Cracker

  TYPE_REGEXP = /[A-Z][a-zA-Z_]+/
  NEW_REGEXP = /(?<type>#{TYPE_REGEXP})(?:\(.+\))?\.new/

  class CompletionContext

    @context : String
    @content : String
    @splitted : Array(String)

    def initialize(@context : String)
      content = ""
      (@context.size-1).downto 0 do |i|
        break unless @context[i].to_s.match /[@A-Za-z0-9_\.]/
        content += @context[i]
      end
      @content = content.reverse
      @splitted = @content.split '.'
    end

    def get_type

      if m = @context.match /#{@splitted.first} = #{NEW_REGEXP}/
        m["type"]
      elsif m = @context.match /#{@splitted.first} : (?<type>#{TYPE_REGEXP})/
        m["type"]
      else
        Server.logger.debug "Can't find the type of \"#{@splitted.first}\""
      end

    end

    def is_class
      @splitted.first.match /^[A-Z]/
    end

    def class_method_pattern(type = @splitted.first)
      "#{type}.#{@splitted[1]?}"
    end

    def instance_method_pattern(type = @splitted.first)
      "#{type}##{@splitted[1]?}"
    end

  end

end