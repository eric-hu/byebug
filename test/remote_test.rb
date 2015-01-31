require 'mocha/mini_test'

module Byebug
  module RemoteTest
    class InterruptTest < TestCase
      def test_interrupt_calls_interrupt_on_current_context
        skip("not sure how to mock out a local provided by a C-extension")
      end
    end

    class StartServerTest < TestCase
      def teardown
        # Byebug#start_server defines an instance variable on the Byebug
        # metaclass during its first run.  This will pollute subsequent runs
        # unless removed.
        if Byebug.instance_variable_defined?(:@thread)
          Byebug.remove_instance_variable(:@thread)
        end
      end

      def test_start_server_starts_only_one_thread
        Mutex.expects(:new).once

        Byebug.start_server()
        Byebug.start_server()
      end

      def test_start_server_calls_a_block_passed_in
        Mutex.stubs(:new)
        yielded = false
        block = lambda { yielded = true }
        Byebug.start_server(&block)

        assert_equal(true, yielded)
      end

      def test_start_server_clears_handler_interface
        skip("determine how handler (local variable?) is set to begin with")
      end

      def test_start_server_starts_byebug
        skip("determine what Byebug.start does")
      end

      def test_start_server_starts_a_tcp_server_with_the_specified_host_and_port
        skip("fails when run first: first call to start_control exits method early")
        Mutex.stubs(:new)
        mock_server = mock("server", addr: [0, 1])
        TCPServer.expects(:new).with("some host", 1234).returns(mock_server)
        Byebug.start_server("some host", 1234)
      end
    end
  end
end
