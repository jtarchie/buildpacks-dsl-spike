require 'spec_helper'

module Buildpacks
  describe 'Bundler formula' do
    let(:formula) { Environment.new.find_formula('bundler') }

    describe '#detect?' do
      it 'requires a Gemfile and `ruby`' do
        expect(File).to receive(:exist?).with('Gemfile').and_return(true)
        expect(formula).to be_detected
      end

      it 'fails without a Gemfile' do
        expect(File).to receive(:exist?).with('Gemfile').and_return(false)
        expect(formula).to_not be_detected
      end
    end

    describe '#compile!' do
      let(:fetcher) do
        Class.new do
          def untar
            'build_dir'
          end
        end
      end

      let(:compile) do
        Class.new do
          extend AttrSplat

          attr_splat :add_to_path
          attr_splat :env
          attr_splat :run
        end
      end

      before do
        stub_const('Buildpacks::Fetch', fetcher)
        stub_const('Buildpacks::Compile', compile)
      end

      it 'downloads and installs bundler' do
        expect(fetcher).to receive(:new)
          .with('https://github.com/bundler/bundler/archive/v1.8.4.tar.gz')
          .call_through

        formula.compile!
      end

      it 'installs gems to the vendor directory' do
        formula.compile!
        expect(compile.run).to include('bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin')
      end

      it 'adds bundler to PATH' do
        expect(formula).to receive(:add_to_path)
          .with('bundler_dir')

        formula.compile!
      end

      context 'with BUNDLE_WITHOUT defined' do
        it 'installs gems with that option' do
          wrap_env('BUNDLE_WITHOUT' => 'test') do
            expect(formula).to receive(:run)
              .with('bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin')

            formula.compile!
          end
        end
      end
    end
  end
end
