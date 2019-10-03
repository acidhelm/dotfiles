require 'irb/completion'
require 'fancy_irb'
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000

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
  def ppa; pp attributes.sort.to_h; 0; end
end

colors =
  {
    input_prompt: %i(white bright blue),
    rocket_prompt: %i(white bright red),
    result_prompt: %i(white bright red),
  }

FancyIrb.start(rocket_mode: false, colorize: colors)
