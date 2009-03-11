module Sinatra
  module Nancy
    module Test
      module Methods
        
        def setup
          Sinatra::Default.set(
            :environment => :test,
            :run => false,
            :raise_errors => true,
            :logging => false
          )
        end

        # Sets up a Sinatra::Base subclass defined with the block
        # given. Used in setup or individual spec methods to establish
        # the application.
        def mock_app(base=Sinatra::Base, &block)
          @app = Sinatra.new(base, &block)
        end
        
        def erb_app(&block)
          mock_app {
            helpers Sinatra::Nancy
            set :views, File.dirname(__FILE__) + '/views'
            get '/', &block
          }
          get '/'
        end

        def test_sinatra(block, options = {})
          res = erb_app { erb block, options }
          should.be.ok?
          @res = body
        end

        def test_class(block)
          @res = block.call
        end

        def elements(css)
           doc = Nokogiri::HTML(@res).search(css)
        end
        
      end
    end
  end
end