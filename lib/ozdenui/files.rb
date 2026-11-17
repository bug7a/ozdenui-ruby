# Bismillah
#
# files.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# The files of a FilePicker with their real paths: a click on it opens the file dialog of the system (the dialog of
# the page gives only names), picker.add_files(paths) and picker.paths.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "find"

module OzdenUI
  # What the gem is made of. A program uses the methods of OzdenUI; these classes are behind them.
  module Runtime
    # @api private
    module Files
      MAX_PREVIEWS = 12                   # more files than this: no pictures in the list (each one is read)
      MAX_PREVIEW_BYTES = 2 * 1024 * 1024 # a larger picture is not read for the list
      # The endings behind a kind of files in the accept of a FilePicker ("image/*").
      ENDINGS_OF_KIND = {
        "image/*" => %w[png jpg jpeg gif webp svg bmp], "audio/*" => %w[mp3 wav ogg m4a flac],
        "video/*" => %w[mp4 mov webm mkv avi], "text/*" => %w[txt md csv json html css js]
      }.freeze

      module_function

      # What the page needs of a file: a plain object in the place of the File object of a browser. nil: not a file.
      def file_for_page(path, with_preview)
        path = File.expand_path(path.to_s)
        return nil unless File.file?(path)
        kind = (Values::MIME_TYPES[File.extname(path).downcase] || "").split(";").first.to_s
        size = File.size(path)
        file = { "name" => File.basename(path), "path" => path, "size" => size, "type" => kind,
                 "lastModified" => (File.mtime(path).to_f * 1000).to_i }
        file["previewAddress"] = Values.picture_of_path(path) if with_preview && kind.start_with?("image/") && size <= MAX_PREVIEW_BYTES
        file
      rescue SystemCallError
        nil
      end

      # The endings of the accept of a FilePicker (".pdf,.docx", "image/*", "image/png"), for the dialog of the system.
      # nil: every file.
      def file_types_of(accept)
        endings = []
        accept.to_s.split(",").each do |part|
          part = part.strip.downcase
          next if part.empty?
          if part.start_with?(".")
            endings << part[1..-1]
          elsif ENDINGS_OF_KIND[part]
            endings.concat(ENDINGS_OF_KIND[part])
          else
            found = Values::MIME_TYPES.select { |_ending, kind| kind.split(";").first == part }.keys
            return nil if found.empty? # WHY: a kind nobody knows the endings of: the dialog must not hide its files
            endings.concat(found.map { |ending| ending[1..-1] })
          end
        end
        endings.empty? ? nil : endings
      end

      # The on_open_dialog of a FilePicker that was given none: the file dialog of the system.
      def open_dialog_of_picker(picker)
        if Values.on?(picker.kept_values["directory"])
          folder = OzdenUI.choose_folder
          picker.add_folder(folder) if folder
          return
        end
        types = file_types_of(picker.kept_values["accept"])
        if Values.on?(picker.kept_values["multiple"])
          paths = OzdenUI.open_files(types: types)
          picker.add_files(paths) unless paths.empty?
          return
        end
        path = OzdenUI.open_file(types: types)
        picker.add_files(path) if path
      end
    end

    class UIObject
      # Adds files of this computer to the list of a FilePicker, with their real paths. Its accept, max_size and
      # max_files look at them too, and its on_change runs. A file that can not be read is told and left out.
      #
      #   picker.add_files("/Users/ada/report.pdf", "notes.txt")
      def add_files(*paths)
        must_be("FilePicker", "add_files")
        paths = paths.flatten
        show_preview = @kept_values["showPreview"]
        with_preview = paths.length <= Files::MAX_PREVIEWS && (show_preview.nil? || Values.on?(show_preview))
        files = paths.map do |path|
          file = Files.file_for_page(path, with_preview)
          @app.warn_at("FilePicker.add_files: #{path} could not be read") unless file
          file
        end
        call(:add_files, files.compact)
      end

      # The files of a FilePicker that have a path on this computer: the ones chosen in the file dialog or given by
      # add_files. A file dropped on the window has only its name (picker.files lists every file).
      def paths
        must_be("FilePicker", "paths")
        Array(@kept_values["files"]).map { |file| file.is_a?(Hash) ? file["path"].to_s : "" }
                                    .select { |path| !path.empty? && File.absolute_path(path) == path }
      end

      # Every file of a folder, as the dialog of the page gives a folder: a row says where its file is.
      # @api private
      def add_folder(folder)
        files = []
        root = File.dirname(folder)
        Find.find(folder) do |path|
          file = File.file?(path) ? Files.file_for_page(path, false) : nil
          next unless file
          file["webkitRelativePath"] = path[(root.length + 1)..-1].to_s.tr("\\", "/")
          files << file
        end
        call(:add_files, files)
      end
    end
  end
end
