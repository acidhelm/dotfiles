require 'irb/completion'
require 'fancy_irb'
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000

class Object
  def sm; methods.sort; end
  def gm(m = nil); m ? sm.grep(m) : sm; end
  def ppa; pp attributes.sort.to_h; 0; end
end

colors =
  {
    input_prompt: [ :white, :bright, :blue ],
    rocket_prompt: [ :white, :bright, :red ],
    result_prompt: [ :white, :bright, :red ],
  }

FancyIrb.start(rocket_mode: false, colorize: colors)
