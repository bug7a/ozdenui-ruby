# Bismillah
# A CSV file in a table: open one (a sample is shown first), click a row to see it; a SmartTable makes only the rows that are seen, so "100000 rows" stays fast.
require "csv"
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
TEXT_SOFT = "#5A6270"
TABLE_WIDTH = 820
TABLE_HEIGHT = 400
COLUMN_WIDTH = 170
MANY_ROWS = 100_000

SAMPLE_COLUMNS = ["city", "country", "people"].freeze
SAMPLE = [
  { "city" => "İstanbul", "country" => "Türkiye", "people" => "15,655,924" },
  { "city" => "Ankara", "country" => "Türkiye", "people" => "5,803,482" },
  { "city" => "Berlin", "country" => "Germany", "people" => "3,878,100" },
  { "city" => "Madrid", "country" => "Spain", "people" => "3,332,035" },
  { "city" => "Rome", "country" => "Italy", "people" => "2,748,109" },
  { "city" => "Paris", "country" => "France", "people" => "2,102,650" },
  { "city" => "Vienna", "country" => "Austria", "people" => "2,005,760" },
  { "city" => "Lisbon", "country" => "Portugal", "people" => "567,131" }
].freeze

@columns = [] # the names of the columns in their order
@table = nil

# Makes a new table for the rows (a new file has other columns).
def show_rows(names, records)
  @table.remove if @table
  @columns = names
  titles = names.map do |name|
    { name: name, dataTitle: name, dataType: "string", width: COLUMN_WIDTH, sortable: 1 }
  end
  @holder.add do
    @table = SmartTable(title_data_list: titles, item_data_list: records, fit_line_count: 1,
                        width: "100%", height: "100%", on_select: method(:show_row))
  end
end

def show_row(_table, row)
  parts = @columns.map { |name| "#{name}: #{row[name]}" }
  @detail.text = parts.join("   ")
end

def show_many_rows
  @file.text = "#{MANY_ROWS} rows made in Ruby"
  records = (0...MANY_ROWS).map do |index|
    { "number" => index, "square" => index * index, "half" => index / 2.0 }
  end
  show_rows(["number", "square", "half"], records)
end

def open_csv
  path = open_file(types: ["csv"])
  return if path.nil?
  begin
    names, records = read_csv(path)
  rescue StandardError => error
    toast_error(error.message, title: "Could not read it")
    return
  end
  @file.text = path
  show_rows(names, records)
end

# Reads a CSV file with a line of titles: a row is a Hash by those titles.
def read_csv(path)
  text = File.read(path, encoding: "UTF-8").sub(/\A﻿/, "") # the mark Excel puts at the start of a UTF-8 file
  lines = CSV.parse(text)
  return [[], []] if lines.empty?
  names = lines.first
  records = lines.drop(1).map do |line|
    record = {}
    names.each_with_index { |name, index| record[name] = line[index] if index < line.length }
    record
  end
  [names, records]
end

run(title: "CSV viewer", width: 900, height: 640) do |page|
  page.color = PAGE_COLOR
  VGroup(gap: 14, padding: 30, align: "left top") do
    HGroup(hug: true, gap: 14, align: "left center") do
      Label(text: "CSV viewer", font_size: 24, bold: true)
      SmartButton(label_text: "Open a CSV", tone: "cyan", on_click: method(:open_csv))
      SmartButton(label_text: "#{MANY_ROWS} rows", on_click: method(:show_many_rows))
    end
    @file = Label(text: "A sample: some cities", font_size: 14, text_color: TEXT_SOFT)
    @holder = Box(width: TABLE_WIDTH, height: TABLE_HEIGHT, color: "transparent")
    @detail = Label(text: "Click a row.", font_size: 15)
  end
  show_rows(SAMPLE_COLUMNS, SAMPLE)
end
