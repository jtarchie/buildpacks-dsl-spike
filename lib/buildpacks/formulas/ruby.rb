formula(:ruby) do
  depends_on :bundler

  detect { File.exists?('Gemfile') }
end
