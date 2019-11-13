require 'irb/completion'
require 'fancy_irb'
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000

FILTER_METHODS_PREFIXES = /\A(?:
  \W |
  __?\w |
  after_add_for_ |
  after_remove_for_ |
  autosave_associated_records_for_ |
  before_add_for_ |
  before_remove_for_ |
  restore_ |
  saved_change_to_ |
  validate_associated_records_for_ |
  will_save_change_to_
  )
  /x

FILTER_METHODS_SUFFIXES = /_(?:
  before_last_save |
  before_type_cast |
  came_from_user\? |
  change |
  change_to_be_saved |
  changed\? |
  in_database |
  previous_change |
  previously_changed\? |
  was |
  will_change!
  )\z
  /x

class Object
  # sm = Sort methods, optionally filtering the names using a pattern.
  def sm(pattern = nil)
    sorted_methods = methods.sort
    pattern ? sorted_methods.grep(pattern) : sorted_methods
  end

  # psm = puts sm
  def psm(pattern = nil)
    puts sm(pattern)
  end
end

class ApplicationRecord
  # An overridden `sm` that doesn't show various `ActiveRecord` methods that we
  # usually don't care about.
  def sm(pattern = nil)
    super(pattern).reject do |m|
      m =~ FILTER_METHODS_PREFIXES || m =~ FILTER_METHODS_SUFFIXES
    end
  end

  # ppa = pretty-print attributes, optionally filtering the names using a pattern.
  def ppa(pattern = nil)
    attrs = attributes.sort
    attrs.select! { |k, v| k =~ pattern } if pattern
    pp attrs.to_h
    0 # Discard the return value from pp, which is the hash.
  end
end

colors =
  {
    input_prompt: %i(white bright blue),
    rocket_prompt: %i(white bright red),
    result_prompt: %i(white bright red),
  }

FancyIrb.start(rocket_mode: false, colorize: colors)
