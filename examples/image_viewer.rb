# Bismillah
# A place to look at a picture: open a file, or draw a plot again and again (the zoom and the place stay); the plot is a PNG made in plain Ruby, given as bytes to picture().
require "zlib"
require "ozdenui"
include OzdenUI

PLOT_WIDTH = 640
PLOT_HEIGHT = 400
PAGE_LIGHT = "#FFFFFF"
PAGE_DARK = "#1E1E1E"
CURVE_WIDTH = 3
PHASE_STEP = 0.5
GRID_STEP = 40

GROUND = [255, 255, 255].pack("C*")
GRID = [225, 228, 232].pack("C*")
CURVE = [43, 140, 150].pack("C*")

@phase = 0.0

# A chunk of a PNG file: its length, its name, its data and their check number.
def png_chunk(name, data)
  [data.bytesize].pack("N") + name + data + [Zlib.crc32(name + data)].pack("N")
end

# The bytes of a PNG file of rows of RGB pixels (each row a text of 3 bytes a pixel).
def png_bytes(rows, width, height)
  header = [width, height, 8, 2, 0, 0, 0].pack("NNCCCCC") # 8 bits, RGB
  pixels = rows.map { |row| "\0".b + row }.join # 0: each row as it is
  "\x89PNG\r\n\x1A\n".b + png_chunk("IHDR", header) + png_chunk("IDAT", Zlib::Deflate.deflate(pixels)) + png_chunk("IEND", "")
end

# Draws a sine pixel by pixel: as a program of yours would draw one.
def plot(phase)
  plain_row = (0...PLOT_WIDTH).map { |x| (x % GRID_STEP).zero? ? GRID : GROUND }.join
  grid_row = GRID * PLOT_WIDTH
  rows = (0...PLOT_HEIGHT).map { |y| ((y % GRID_STEP).zero? ? grid_row : plain_row).dup }
  PLOT_WIDTH.times do |x|
    y = PLOT_HEIGHT / 2 - (Math.sin(x / 50.0 + phase) * PLOT_HEIGHT * 0.35).to_i
    CURVE_WIDTH.times do |thickness|
      row = rows[y + thickness]
      row[x * 3, 3] = CURVE if row && y + thickness >= 0 # a point outside the picture is left out
    end
  end
  png_bytes(rows, PLOT_WIDTH, PLOT_HEIGHT)
end

def show_size(view)
  zoom = (view.zoom_level.to_f * 100).round
  @status.set_item_text("size", "#{view.natural_width.to_i} x #{view.natural_height.to_i} at #{zoom}%")
end

def draw_again
  @phase += PHASE_STEP
  @viewer.set_image(picture(plot(@phase)))
  @status.set_message_text("Drawn again: the zoom and the place stay", "success", 2000)
end

def open_picture
  path = open_file(types: ["png", "jpg", "jpeg", "gif", "webp", "svg"])
  return if path.nil?
  @viewer.set_image(picture(path))
  @status.set_message_text(path)
end

run(title: "Image viewer", width: 760, height: 560) do |page|
  page.color = dark? ? PAGE_DARK : PAGE_LIGHT
  VGroup(gap: 0, align: "left top") do
    HGroup(width: "100%", height: "auto", gap: 8, padding: 12, align: "left center", shrink: 0) do
      SmartButton(label_text: "Open a picture", tone: "cyan", on_click: method(:open_picture))
      SmartButton(label_text: "Draw the plot again", on_click: method(:draw_again))
    end
    @viewer = ImageView(fill: true, unframed: true, image_file: picture(plot(@phase)),
                        alt_text: "A plot", on_zoom_change: method(:show_size),
                        on_error: -> { @status.set_message_text("It can not be opened", "error") })
    @status = StatusBar(message_text: "A plot", items: [{ key: "size", text: "-" }])
  end
end
