($:.unshift '..'; require 'coderay') unless defined? CodeRay
module CodeRay
  
  # = Duo
  #
  # A Duo is a convenient way to use CodeRay. You just create a Duo,
  # giving it a lang (language of the input code) and a format (desired
  # output format), and call Duo#highlight with the code.
  # 
  # Duo makes it easy to re-use both scanner and encoder for a repetitive
  # task. It also provides a very easy interface syntax:
  # 
  #   require 'coderay'
  #   CodeRay::Duo[:python, :div].highlight 'import this'
  # 
  # Until you want to do uncommon things with CodeRay, I recommend to use
  # this method, since it takes care of everything.
  class Duo

    attr_accessor :lang, :format, :options
    
    # Create a new Duo, holding a lang and a format to highlight code.
    # 
    # simple:
    #   CodeRay::Duo[:ruby, :page].highlight 'bla 42'
    # 
    # with options:
    #   CodeRay::Duo[:ruby, :html, :hint => :debug].highlight '????::??'
    # 
    # alternative syntax without options:
    #   CodeRay::Duo[:ruby => :statistic].encode 'class << self; end'
    # 
    # alternative syntax with options:
    #   CodeRay::Duo[{ :ruby => :statistic }, :do => :something].encode 'abc'
    # 
    # The options are forwarded to scanner and encoder
    # (see CodeRay.get_scanner_options).
    def initialize lang = nil, format = nil, options = {}
      if format == nil and lang.is_a? Hash and lang.size == 1
        @lang = lang.keys.first
        @format = lang[@lang]
      else
        @lang = lang
        @format = format
      end
      @options = options
    end
    
    class << self
      # To allow calls like Duo[:ruby, :html].highlight.
      alias [] new
    end
    
    # The scanner of the duo. Only created once.
    def scanner
      @scanner ||= CodeRay.scanner @lang, CodeRay.get_scanner_options(@options)
    end
    
    # The encoder of the duo. Only created once.
    def encoder
      @encoder ||= CodeRay.encoder @format, @options
    end
    
    # Tokenize and highlight the code using +scanner+ and +encoder+.
    def encode code, options = {}
      options = @options.merge options
      encoder.encode(code, @lang, options)
    end
    alias highlight encode
    
    # Allows to use Duo like a proc object:
    # 
    #  CodeRay::Duo[:python => :yaml].call(code)
    # 
    # or, in Ruby 1.9 and later:
    # 
    #  CodeRay::Duo[:python => :yaml].(code)
    alias call encode
    
  end
  
end

if $0 == __FILE__
  $VERBOSE = true
  $: << File.join(File.dirname(__FILE__), '..')
  eval DATA.read, nil, $0, __LINE__ + 4
end

__END__
require 'test/unit'

class DuoTest < Test::Unit::TestCase
  
  def test_two_arguments
    duo = CodeRay::Duo[:ruby, :html]
    assert_kind_of CodeRay::Scanners[:ruby], duo.scanner
    assert_kind_of CodeRay::Encoders[:html], duo.encoder
  end
  
  def test_two_hash
    duo = CodeRay::Duo[:ruby => :html]
    assert_kind_of CodeRay::Scanners[:ruby], duo.scanner
    assert_kind_of CodeRay::Encoders[:html], duo.encoder
  end
  
  def test_call
    duo = CodeRay::Duo[:python => :yaml]
    assert_equal <<-'YAML', duo.call('def test: "pass"')
--- 
- - def
  - :keyword
- - " "
  - :space
- - test
  - :method
- - ":"
  - :operator
- - " "
  - :space
- - :begin_group
  - :string
- - "\""
  - :delimiter
- - pass
  - :content
- - "\""
  - :delimiter
- - :end_group
  - :string
    YAML
  end
  
end
