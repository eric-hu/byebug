module Byebug
  # Stores program being debugged to make restarts possible
  PROG_SCRIPT = $PROGRAM_NAME unless defined?(PROG_SCRIPT)
  #
  # Enters byebug right before (or right after if _before_ is false) return
  # events occur. Before entering byebug the init script is read.
  #
  def self.attach(steps_out, before)
    start
    run_init_script(StringIO.new)
    current_context.step_out(steps_out, before)
  end
end

#
# Adds a `byebug` method to the Kernel module.
#
# Dropping a `byebug` call anywhere in your code, you get a debug prompt.
#
module Kernel
  def byebug(steps_out = 1, before = true)
    Byebug.attach(steps_out + 1, before)
  end

  alias_method :debugger, :byebug
end
