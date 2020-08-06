def clear_downloads
  files = Dir["#{ENV['DOWNLOAD_DIR']}/*"]
  FileUtils.rm_rf files

end