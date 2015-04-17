require 'ostruct'
module Byebug
  #
  # Tests control command functionality.
  #
  class ControlCommandProcessorTest < TestCase


    def test_initialize_sets_a_default_interface
      processor = ControlCommandProcessor.new

      assert_equal(processor.interface.class, LocalInterface)
    end

    def test_commands_filters_non_control_commands
      mock_control_command = mock()
      mock_control_command.stubs(:allow_in_control).returns(true)
      mock_non_control_command = mock()
      mock_non_control_command.stubs(:allow_in_control).returns(false)

      mock_control_command.stubs(:new).returns("control")
      mock_non_control_command.stubs(:new).returns("non control")

      mock_commands = [
          mock_control_command,
          mock_non_control_command,
          mock_control_command,
          mock_control_command,

      ]
      processor = ControlCommandProcessor.new


      Byebug.stubs(:commands).returns(mock_commands)
      assert_equal(processor.commands.count, 3)
    end

    def test_process_commands_closes_the_interface_on_completion
      mock_state = mock()
      mock_state.stubs(:new).returns(true)
      ControlState.stubs(:new).returns(mock_state)

      mock_interface = mock()
      mock_interface.stubs(:read_command)
      processor = ControlCommandProcessor.new(mock_interface)

      mock_interface.expects(:close)
      processor.process_commands
    end
  end
end
