# -*- encoding : utf-8 -*-
# tell the I18n library where to find your translations
I18n.load_path += Dir[ File.join(Rails.root, 'lib', 'locale', '*.{rb,yml}') ]

# you can omit this if you're happy with English as a default locale
I18n.default_locale = "zh"
