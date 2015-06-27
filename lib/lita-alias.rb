# rubocop:disable Style/FileName
require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'),
  __FILE__
)]

require 'lita/alias/chat_handler'

Lita::Alias::ChatHandler.template_root File.expand_path(
  File.join('..', '..', 'templates'),
  __FILE__
)
