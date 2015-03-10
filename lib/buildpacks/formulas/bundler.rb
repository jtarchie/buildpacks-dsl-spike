formula(:bundler) do
  detect { File.exist?('Gemfile') && which('ruby').exist? }

  compile do
    bundler_dir = fetch('https://github.com/bundler/bundler/archive/v1.8.4.tar.gz').untar
    add_to_path File.join(bundler_dir, 'bin')
    bundle_without = env('BUNDLE_WITHOUT', 'development:test')
    run "bundle install --without #{bundle_without} --path vendor/bundle --binstubs vendor/bundle/bin"
  end
end
