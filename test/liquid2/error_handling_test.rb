require 'test_helper'

class ErrorDrop < Liquid2::Drop
  def standard_error
    raise Liquid2::StandardError, 'standard error'
  end

  def argument_error
    raise Liquid2::ArgumentError, 'argument error'
  end

  def syntax_error
    raise Liquid2::SyntaxError, 'syntax error'
  end

  def exception
    raise Exception, 'exception'
  end

end

class ErrorHandlingTest < Test::Unit::TestCase
  include Liquid2

  def test_standard_error
    assert_nothing_raised do
      template = Liquid2::Template.parse( ' {{ errors.standard_error }} '  )
      assert_equal ' Liquid error: standard error ', template.render('errors' => ErrorDrop.new)

      assert_equal 1, template.errors.size
      assert_equal StandardError, template.errors.first.class
    end
  end

  def test_syntax

    assert_nothing_raised do

      template = Liquid2::Template.parse( ' {{ errors.syntax_error }} '  )
      assert_equal ' Liquid syntax error: syntax error ', template.render('errors' => ErrorDrop.new)

      assert_equal 1, template.errors.size
      assert_equal SyntaxError, template.errors.first.class

    end
  end

  def test_argument
    assert_nothing_raised do

      template = Liquid2::Template.parse( ' {{ errors.argument_error }} '  )
      assert_equal ' Liquid error: argument error ', template.render('errors' => ErrorDrop.new)

      assert_equal 1, template.errors.size
      assert_equal ArgumentError, template.errors.first.class
    end
  end

  def test_missing_endtag_parse_time_error
    assert_raise(Liquid2::SyntaxError) do
      template = Liquid2::Template.parse(' {% for a in b %} ... ')
    end
  end

  def test_unrecognized_operator
    assert_nothing_raised do
      template = Liquid2::Template.parse(' {% if 1 =! 2 %}ok{% endif %} ')
      assert_equal ' Liquid error: Unknown operator =! ', template.render
      assert_equal 1, template.errors.size
      assert_equal Liquid2::ArgumentError, template.errors.first.class
    end
  end

  # Liquid should not catch Exceptions that are not subclasses of StandardError, like Interrupt and NoMemoryError
  def test_exceptions_propagate
    assert_raise Exception do
      template = Liquid2::Template.parse( ' {{ errors.exception }} '  )
      template.render('errors' => ErrorDrop.new)
    end
  end
end # ErrorHandlingTest
