module Rcap
  module Generators
    class ModelsGenerator < Rails::Generators::Base
      desc <<DESC
Description:
    Copy RCAP models to your application.
DESC

      def self.source_root
        @_rcap_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def self.banner
        "rails generate rcap:models"
      end

      def copy_model_files
        directory 'models', 'app/models'
      end

      def copy_lib_files
        copy_file 'modules/rcap.rb', 'lib/rcap.rb'
      end

      private

      def print_usage
        self.class.help(Thor::Base.shell.new)
        exit
      end
    end
  end
end