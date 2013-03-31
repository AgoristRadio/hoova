$LOAD_PATH.unshift(File.expand_path('lib/'))
$LOAD_PATH.unshift(File.expand_path('lib/bitcoin-client/lib/'))

require 'factory_girl'
require 'hoova'
FactoryGirl.definition_file_paths = %w(custom_factories_directory)
FactoryGirl.find_definitions