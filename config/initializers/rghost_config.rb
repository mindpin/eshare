gs_path = `which gs`.gsub(/\r?\n/,"")
if !gs_path.blank?
  RGhost::Config::GS[:path] = gs_path
end