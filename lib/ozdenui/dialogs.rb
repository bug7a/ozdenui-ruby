# Bismillah
#
# dialogs.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# Dialogs that return their answer (the window keeps working while the code waits), toasts, and the file dialogs of
# the system.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "open3"
require "rbconfig"

module OzdenUI
  # What the gem is made of. A program uses the methods of OzdenUI; these classes are behind them.
  module Runtime
    # @api private
    module Dialogs
      module_function

      def show(method, params)
        app = OzdenUI.current_app
        app.check("#{method} dialog")
        look = {}
        Maker.take_window_look(app, Kit["Dialog"], look)
        params["styleName"] = look["styleName"] if look["styleName"]
        # A text that was not given: the text of the kit
        params.delete_if { |key, value| value.nil? || (value == "" && !%w[messageText value].include?(key)) }
        app.call_static("Dialog", method, [params], wait: true)
      end

      def toast(kind, message, title)
        app = OzdenUI.current_app
        theme = app.theme
        if app.minimal?
          theme = app.options[:accent] ? App::ACCENT_STYLE_NAME : "minimal"
          theme += "Dark" if app.dark?
        end
        params = { "messageText" => message.to_s, "type" => kind.to_s, "theme" => theme }
        params["titleText"] = title.to_s if title
        app.call_static("Toast", "show", [params])
        nil
      end

      # *** THE FILE DIALOGS OF THE SYSTEM. They return real paths; none when cancelled.

      def system_name
        host = RbConfig::CONFIG["host_os"]
        return :mac if host =~ /darwin/
        return :windows if host =~ /mswin|mingw|cygwin/
        :linux
      end

      def file_dialog(kind, title: nil, directory: nil, file_name: nil, types: nil)
        app = OzdenUI.app
        app.flush if app && app.app_thread? # what the program drew before the dialog is on the page
        types = Array(types).map { |ending| ending.to_s.sub(/\A\./, "") }
        if system_name == :windows
          lines = windows_dialog(power_shell(kind, title, directory, file_name, types))
          return lines if lines
        end
        command = case system_name
                  when :mac then ["osascript", "-e", apple_script(kind, title, directory, file_name, types)]
                  when :windows then ["powershell", "-NoProfile", "-STA", "-Command", power_shell(kind, title, directory, file_name, types)]
                  else zenity(kind, title, directory, file_name, types)
                  end
        output, = Open3.capture2(*command, err: File::NULL)
        output.force_encoding("UTF-8").split("\n").map(&:strip).reject(&:empty?)
      rescue SystemCallError => error
        $stderr.puts "ozdenui: the file dialog of the system could not open: #{error.message}"
        []
      end

      # The lines of the dialog of Windows, started without a console window (hidden_process.rb); nil when fiddle
      # could not be used (then Open3 starts it, as before).
      def windows_dialog(script)
        require_relative "hidden_process"
        HiddenProcess.run_power_shell(script)
      rescue LoadError, Fiddle::DLError => error
        $stderr.puts "ozdenui: the file dialog opens with a console window (#{error.message})"
        nil
      end

      def quoted(text)
        %("#{text.to_s.gsub('\\') { '\\\\' }.gsub('"') { '\\"' }}")
      end

      def apple_script(kind, title, directory, file_name, types)
        extra = +""
        extra << " with prompt #{quoted(title)}" if title
        extra << " default location POSIX file #{quoted(File.expand_path(directory))}" if directory
        of_type = types.empty? ? "" : " of type {#{types.map { |ending| quoted(ending) }.join(', ')}}"
        choose = case kind
                 when :open then "set chosen to {choose file#{of_type}#{extra}}"
                 when :open_many then "set chosen to choose file#{of_type}#{extra} with multiple selections allowed"
                 when :save then "set chosen to {choose file name#{extra}#{file_name ? " default name #{quoted(file_name)}" : ''}}"
                 else "set chosen to {choose folder#{extra}}"
                 end
        # WHY the front application: the dialog belongs to the window of the program, so it opens in front of it
        "tell application (path to frontmost application as text)\n#{choose}\nend tell\n" \
          "set out to \"\"\nrepeat with one in chosen\nset out to out & POSIX path of one & linefeed\nend repeat\nout"
      end

      def power_shell(kind, title, directory, file_name, types)
        single = ->(text) { "'#{text.to_s.gsub("'", "''")}'" }
        script = +"Add-Type -AssemblyName System.Windows.Forms; [Console]::OutputEncoding = [Text.Encoding]::UTF8; "
        if kind == :folder
          script << "$d = New-Object System.Windows.Forms.FolderBrowserDialog; "
          script << "$d.Description = #{single.call(title)}; " if title
          script << "$d.SelectedPath = #{single.call(directory)}; " if directory
          return script + "if ($d.ShowDialog() -eq 'OK') { $d.SelectedPath }"
        end
        script << "$d = New-Object System.Windows.Forms.#{kind == :save ? 'SaveFileDialog' : 'OpenFileDialog'}; "
        script << "$d.Title = #{single.call(title)}; " if title
        script << "$d.InitialDirectory = #{single.call(directory)}; " if directory
        script << "$d.FileName = #{single.call(file_name)}; " if file_name
        unless types.empty?
          list = types.map { |ending| "*.#{ending}" }.join(";")
          script << "$d.Filter = #{single.call("Files (#{list})|#{list}|All files (*.*)|*.*")}; "
        end
        script << "$d.Multiselect = $true; " if kind == :open_many
        script + "if ($d.ShowDialog() -eq 'OK') { $d.FileNames }"
      end

      def zenity(kind, title, directory, file_name, types)
        args = ["zenity", "--file-selection"]
        args << "--title=#{title}" if title
        args.push("--multiple", "--separator=\n") if kind == :open_many
        args.push("--save", "--confirm-overwrite") if kind == :save
        args << "--directory" if kind == :folder
        start = directory.to_s
        start += "/" unless start.empty? || start.end_with?("/")
        args << "--filename=#{start}#{file_name}" unless "#{start}#{file_name}".empty?
        args << "--file-filter=#{types.map { |ending| "*.#{ending}" }.join(' ')}" unless types.empty?
        args
      end
    end
  end

  module_function

  # Shows a message and waits until it is closed.
  def alert(message, title: nil, confirm_text: nil)
    Runtime::Dialogs.show("alert", "titleText" => title, "messageText" => message.to_s, "buttonText" => confirm_text)
    nil
  end

  # Asks a yes / no question: delete_all if confirm("Delete the list?", danger: true)
  # danger: the yes button is red (a delete).
  def confirm(message, title: "Are you sure?", confirm_text: nil, cancel_text: nil, danger: false)
    Runtime::Values.on?(Runtime::Dialogs.show("confirm", "titleText" => title, "messageText" => message.to_s, "confirmText" => confirm_text,
                                       "cancelText" => cancel_text, "danger" => danger ? 1 : 0))
  end

  # Asks for a text; nil when the dialog was cancelled: name = prompt("The name of the list:")
  # value: the text in the field at the start; field_text: the title of the field; required: an empty answer is not taken.
  def prompt(message, title: nil, value: "", placeholder: nil, field_text: nil, required: false, confirm_text: nil, cancel_text: nil)
    answer = Runtime::Dialogs.show("prompt", "titleText" => title, "messageText" => message.to_s, "value" => value.to_s,
                                    "placeholder" => placeholder, "fieldText" => field_text, "required" => required ? 1 : 0,
                                    "confirmText" => confirm_text, "cancelText" => cancel_text)
    answer.nil? ? nil : Runtime::Values.text_of(answer)
  end

  # Shows a message with buttons of the program and returns the text of the pressed one (nil: closed with Escape or a
  # click outside). The first button is the main one.
  #
  #   case ask("Save the changes?", "Save", "Don't save", "Cancel") ...
  def ask(message, *buttons, title: nil)
    app = OzdenUI.current_app
    app.check("ask")
    buttons = ["OK"] if buttons.empty?
    list = buttons.each_with_index.map { |text, index| { "text" => text.to_s, "key" => text.to_s, "type" => index.zero? ? "primary" : "secondary" } }
    pending = Runtime::Answer.new
    props = { message_text: message.to_s, buttons: list, on_close: ->(_dialog, reason, key) { pending.give(reason == "button" ? key : nil) } }
    props[:title_text] = title.to_s if title
    dialog = Runtime::Maker.component("Dialog", [], props, nil)
    # WHY by the id of the dialog: when the page can not make it, its answer is nil (the code would wait for ever)
    app.wait_for_answer(dialog.id, pending)
  end

  # A small message for a while, that never waits: toast("Saved."), toast("No file.", type: :error, title: "Open")
  # type: :success (default), :error, :warning, :info.
  def toast(message, type: :success, title: nil)
    Runtime::Dialogs.toast(type, message, title)
  end

  def toast_success(message, title: nil)
    Runtime::Dialogs.toast(:success, message, title)
  end

  def toast_error(message, title: nil)
    Runtime::Dialogs.toast(:error, message, title)
  end

  def toast_warning(message, title: nil)
    Runtime::Dialogs.toast(:warning, message, title)
  end

  def toast_info(message, title: nil)
    Runtime::Dialogs.toast(:info, message, title)
  end

  # The path of the file the user chose in the file dialog of the system (nil: cancelled).
  # title:, directory: the folder it opens in, types: the endings it shows (%w[png jpg]).
  def open_file(**options)
    Runtime::Dialogs.file_dialog(:open, **options).first
  end

  # As open_file, with more than one file: a list of paths (empty: cancelled).
  def open_files(**options)
    Runtime::Dialogs.file_dialog(:open_many, **options)
  end

  # The path to save to (nil: cancelled). The file is not made: the program writes it. file_name: the name it offers.
  def save_file(**options)
    Runtime::Dialogs.file_dialog(:save, **options).first
  end

  # The path of the folder the user chose (nil: cancelled).
  def choose_folder(**options)
    Runtime::Dialogs.file_dialog(:folder, **options).first
  end
end
