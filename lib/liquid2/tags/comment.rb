module Liquid2
  class Comment < Block
    def render(context)
      ''
    end
  end

  Template.register_tag('comment', Comment)
end
