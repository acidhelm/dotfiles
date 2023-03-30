# rubocop:disable all
require 'irb/completion'
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:USE_COLORIZE] = false
IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:INSPECT_MODE] = ->(o) { o.inspect }

prompt = IRB.conf[:PROMPT][:CLASSIC].dup
"INSC".each_char do |c|
  key = :"PROMPT_#{c}"
  prompt[key] = "\e[44m" + prompt[key].strip + "\e[0m " # white on blue
end
prompt[:RETURN] = "\e[41m=> \e[0m%s\n" # white on red
IRB.conf[:PROMPT][:MDUNN] = prompt
IRB.conf[:PROMPT_MODE] = :MDUNN

# Filter out methods that start with \W or an underscore.  \W are operators, and a leading underscore denotes
# an internal method.  We also filter out methods with one of these prefixes, which are `ActiveRecord`
# methods that usually aren't useful to see.
FILTER_METHODS_PREFIXES = /^(?:\W|_|(?:
  after_add_for |
  after_remove_for |
  autosave_associated_records_for |
  before_add_for |
  before_remove_for |
  restore |
  saved_change_to |
  validate_associated_records_for |
  will_save_change_to
  )_)/x

# Filter out methods with these suffixes, which are `ActiveRecord` methods that aren't useful usually to see.
FILTER_METHODS_SUFFIXES = /_(?:
  before_last_save |
  before_type_cast |
  came_from_user\? |
  change |
  change_to_be_saved |
  changed\? |
  for_database |
  in_database |
  previous_change |
  previously_changed\? |
  was |
  will_change!
  )$
  /x

class Object
  # sm = Sort methods, optionally filtering the names using a pattern.
  def sm(pattern = nil)
    (pattern ? methods.grep(pattern) : methods).sort
  end

  # psm = puts sm
  def psm(pattern = nil)
    puts sm(pattern)
  end
end

class ActiveRecord::Base
  # An overridden `sm` that doesn't show various `ActiveRecord` methods that we
  # usually don't care about.  Pass `true` as the second param to see everything.
  def sm(pattern = nil, show_all = false)
    return super(pattern) if show_all
    super(pattern).reject do |m|
      m =~ FILTER_METHODS_PREFIXES || m =~ FILTER_METHODS_SUFFIXES
    end
  end

  def psm(pattern = nil, show_all = false)
    puts sm(pattern, show_all)
  end

  # Convenience methods for calling `sm` or `psm` with `show_all` = true.
  def sma(pattern = nil)
    sm(pattern, true)
  end

  def psma(pattern = nil)
    psm(pattern, true)
  end

  # ppa = pretty-print attributes, optionally filtering the names using a pattern.
  def ppa(pattern = nil)
    attrs = attributes
    attrs.select! { |k, _| k =~ pattern } if pattern
    pp attrs.sort.to_h
    0 # Discard the return value from pp, which is the hash.
  end
end if defined? ActiveRecord

def r!; reload!; end if defined? Rails

# Turn off SQL logging for a block of code.
def qq
  ActiveRecord::Base.logger.silence { yield }
  0
end if defined? ActiveRecord
