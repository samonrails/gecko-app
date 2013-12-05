class BarcodesController < ApplicationController
  def show
    require 'barby/barcode/ean_13'
    require 'barby/outputter/ascii_outputter'
    require 'barby/outputter/html_outputter'
    require 'barby/outputter/pdfwriter_outputter'
    require 'barby/outputter/png_outputter'
    require 'barby/outputter/rmagick_outputter'
    require 'barby/outputter/svg_outputter'
    @barcode = Barby::EAN13.new(params[:id])
    respond_to do |format|
      format.html
      format.png do
        send_data @barcode.to_png(xdim: (params[:width] || 3).to_i)
      end
      format.gif do
        send_data @barcode.to_gif(xdim: (params[:width] || 3).to_i)
      end
      format.jpg do
        send_data @barcode.to_jpg(xdim: (params[:width] || 3).to_i)
      end
    end
  end
end