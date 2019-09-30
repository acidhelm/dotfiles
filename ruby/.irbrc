require 'irb/completion'
require 'fancy_irb'
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000

class Object
  def sm; methods.sort; end
  def gm(m = nil); m ? sm.grep(m) : sm; end
  def psm; puts sm; end
  def pgm(m = nil); puts gm(m); end
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
