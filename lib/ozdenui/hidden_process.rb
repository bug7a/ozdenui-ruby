# Bismillah
#
# hidden_process.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# Windows: a PowerShell script run without a console window, its output read back. Used by the file dialogs.
# WHY: a program without a console (rubyw, a .rbw file opened with a double click) got a new console window behind
# every file dialog: Open3 starts powershell as a console program, and Windows gives it a console of its own. Here
# CreateProcessW starts it with CREATE_NO_WINDOW (fiddle, the library of Ruby that calls the functions of the system).
# The script comes as -EncodedCommand (no quoting of the command line) and writes its lines into a file in UTF-8.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "fiddle"
require "tmpdir"
require "securerandom"

module OzdenUI
  module Runtime
    # @api private
    module HiddenProcess
      module_function

      CREATE_NO_WINDOW = 0x08000000
      WAIT_FOREVER = -1 # INFINITE (0xFFFFFFFF) as the signed 32-bit int of the call
      # The sizes of STARTUPINFOW and PROCESS_INFORMATION in a 64-bit and in a 32-bit Ruby
      STARTUP_INFO_SIZE = (Fiddle::SIZEOF_VOIDP == 8) ? 104 : 68
      PROCESS_INFO_SIZE = (Fiddle::SIZEOF_VOIDP * 2) + 8

      # The lines the script wrote, [] when it wrote none (a cancelled dialog).
      def run_power_shell(script)
        output = File.join(Dir.tmpdir, "ozdenui-#{SecureRandom.hex(6)}.txt")
        run(command_line(script, output))
        return [] unless File.exist?(output)
        File.read(output, encoding: "UTF-8").split(/\r?\n/).map(&:strip).reject(&:empty?)
      ensure
        File.delete(output) if output && File.exist?(output)
      end

      # The command line of powershell; the script writes what it gives into the file at the path output.
      def command_line(script, output)
        quoted = output.gsub("'", "''")
        whole = "$lines = & { #{script} }; " \
                "if ($lines) { [IO.File]::WriteAllLines('#{quoted}', [string[]]$lines, (New-Object Text.UTF8Encoding $false)) }"
        encoded = [whole.encode("UTF-16LE")].pack("m0")
        "powershell.exe -NoProfile -NonInteractive -STA -EncodedCommand #{encoded}"
      end

      # Starts the command without a window and waits until it ends.
      # WHY the wait does not stop the program: a call of fiddle leaves Ruby free, so the server and the other threads
      #     go on while the dialog is open.
      def run(command)
        bytes = command.encode("UTF-16LE").b + "\0\0".b
        line = Fiddle::Pointer.malloc(bytes.bytesize, Fiddle::RUBY_FREE)
        line[0, bytes.bytesize] = bytes
        startup = Fiddle::Pointer.malloc(STARTUP_INFO_SIZE, Fiddle::RUBY_FREE)
        startup[0, STARTUP_INFO_SIZE] = "\0".b * STARTUP_INFO_SIZE
        startup[0, 4] = [STARTUP_INFO_SIZE].pack("L")
        process = Fiddle::Pointer.malloc(PROCESS_INFO_SIZE, Fiddle::RUBY_FREE)
        process[0, PROCESS_INFO_SIZE] = "\0".b * PROCESS_INFO_SIZE
        started = functions[:create].call(nil, line, nil, nil, 0, CREATE_NO_WINDOW, nil, nil, startup, process)
        raise SystemCallError.new("CreateProcessW", Fiddle.win32_last_error.to_i) if started.zero?
        handles = process[0, Fiddle::SIZEOF_VOIDP * 2].unpack((Fiddle::SIZEOF_VOIDP == 8) ? "Q2" : "L2")
        functions[:wait].call(handles[0], WAIT_FOREVER)
        handles.each { |handle| functions[:close].call(handle) }
      end

      def functions
        @functions ||= begin
          kernel = Fiddle.dlopen("kernel32")
          pointer = Fiddle::TYPE_VOIDP
          {
            create: Fiddle::Function.new(kernel["CreateProcessW"],
                                         [pointer, pointer, pointer, pointer, Fiddle::TYPE_INT, Fiddle::TYPE_INT,
                                          pointer, pointer, pointer, pointer], Fiddle::TYPE_INT),
            wait: Fiddle::Function.new(kernel["WaitForSingleObject"], [pointer, Fiddle::TYPE_INT], Fiddle::TYPE_INT),
            close: Fiddle::Function.new(kernel["CloseHandle"], [pointer], Fiddle::TYPE_INT),
          }
        end
      end
    end
  end
end
