class PDFConvert
  def initialize(pdf_path, dest)
    @dest = dest
    @converter = RGhost::Convert.new(pdf_path)
  end

  def convert
    FileUtils.mkdir_p File.dirname(@dest)
    @converter.to(:png,
                  :filename   => @dest,
                  :multipage  => true,
                  :resolution => 300)
    FileUtils.rm @dest
  end
end
