class PDFConvert
  def initialize(pdf_path)
    @name = File.basename(pdf_path, '.pdf')
    @dest = File.join(File.dirname(pdf_path), @name)
    @converter = RGhost::Convert.new(pdf_path)
  end

  def convert
    @converter.to(:png,
                  :filename   => @dest,
                  :multiple   => true,
                  :resolution => 300)
  end
end
